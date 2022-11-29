import 'dart:async';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:property_inspect/data/types/optional.dart';
import 'package:property_inspect/domain/entities/visitor.dart';
import 'package:property_inspect/application/usecase/analytics_use_case.dart';
import 'package:property_inspect/application/usecase/get_listing_use_case.dart';
import 'package:property_inspect/application/usecase/get_login_id_use_case.dart';
import '../../domain/entities/listing.dart';
import '../../data/types/state.dart' as s;
import '../../application/usecase/checked_in_use_case.dart';
import '../../application/usecase/do_checkin_use_case.dart';
import '../../application/usecase/get_visitor_use_case.dart';
import 'package:rxdart/rxdart.dart' as rx_raw;

class CheckinController extends GetxController {
  final CheckedInUseCase _isCheckedInUseCase;
  final GetLoginIdUseCase _getLoginIdUseCase;
  final DoCheckinUseCase _doCheckinUseCase;
  final GetListingUseCase _getListingUseCase;
  final GetVisitorUseCase _getVisitorUseCase;
  final AnalyticsUseCase _analyticsUseCase;

  // ignore: unnecessary_cast
  final Rx<String?> _propertyId = (null as String?).obs;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final Rx<s.State<bool>> _checkInState = s.State<bool>().obs;
  final Rx<s.State<bool>> _doCheckInState = s.State<bool>().obs;
  final Rx<s.State<Listing>> _propertyState = s.State<Listing>().obs;
  final Rx<s.State<Visitor>> _getVisitorState = s.State<Visitor>().obs;

  StreamSubscription? _getVisitorSubscription;
  StreamSubscription? getIsCheckedInSubscription;
  StreamSubscription? _getPropertySubscription;

  Logger logger = Get.find();

  CheckinController(this._isCheckedInUseCase, this._getLoginIdUseCase, this._doCheckinUseCase, this._getListingUseCase,
      this._getVisitorUseCase, this._analyticsUseCase);

  @override
  void onInit() {
    super.onInit();
    setupStreams();
  }

  void setupStreams() {
    final Stream<Optional<String>> loginIdStream = _getLoginIdUseCase.execute().asBroadcastStream();
    _userId.bindStream(loginIdStream.handleError((onError) {}));

    setupSubscriptionToGetVisitor(loginIdStream);
    setupSubscriptionToGetProperty(loginIdStream, _propertyId.stream);
    setupSubscriptionToGetIsCheckedIn(_propertyState.stream, _getVisitorState.stream, _userId.stream);
  }

  void setupSubscriptionToGetVisitor(Stream<Optional<String>> loginIdStream) {
    _getVisitorSubscription = loginIdStream.listen((value) {
      if (value.value != null) {
        _getVisitor();
      }
    });
  }

  void setupSubscriptionToGetProperty(Stream<Optional<String>> loginIdStream, Stream<String?> propertyIdStream) {
    final lumpedPropertyInputStream = rx_raw.Rx.combineLatest2(propertyIdStream, loginIdStream, (propertyId, loginId) {
      return GetPropertyLumpedInputData(propertyId: propertyId, userId: loginId.value);
    });

    _getPropertySubscription = lumpedPropertyInputStream.listen((data) {
      if (data.userId != null && data.propertyId != null) {
        _getProperty();
      }
    });
  }

  void setupSubscriptionToGetIsCheckedIn(
      Stream<s.State<Listing>> propertyStream, Stream<s.State<Visitor>> visitorStream, Stream<Optional<String>> loginIdStream) {
    final combinedCheckinInputs = rx_raw.Rx.combineLatest3(propertyStream, visitorStream, loginIdStream, (property, visitor, userId) {
      return CheckinLumpedInputData(
        listing: property.content,
        visitor: visitor.content,
      );
    });

    getIsCheckedInSubscription = combinedCheckinInputs.listen((value) {
      final visitor = value.visitor;
      final listing = value.listing;
      if (visitor != null && listing != null) {
        _getIsCheckedIn(listing, visitor);
      }
    });
  }

  Optional<String> _getUserId() {
    return _userId.value;
  }

  _getIsCheckedIn(Listing listing, Visitor visitor) {
    try {
      final listingId = listing.id;
      if (listingId != null) {
        final listingId = listing.id!;
        final listerId = listing.userId;
        final visitorId = visitor.id;

        _checkInState.value = s.State<bool>(loading: true);
        final isCheckedIn = _isCheckedInUseCase.execute(listerId, visitorId, listingId);

        final mappedCheckin = isCheckedIn.map((event) => s.State<bool>(content: event));

        _checkInState.bindStream(mappedCheckin.handleError((onError) => _checkInState.value = s.State<bool>(error: onError)));
      }
    } catch (e) {
      _checkInState.value = s.State<bool>(error: Exception("$e"));
    }
  }

  getIsCheckedIn() {
    return _checkInState.value.content == true;
  }

  getIsLoading() {
    return _propertyState.value.loading == true || _checkInState.value.loading == true || _doCheckInState.value.loading == true;
  }

  void setPropertyId(String? propertyId) {
    _propertyId.value = propertyId;
  }

  String? getPropertyId() {
    return _propertyId.value;
  }

  _getProperty() {
    try {
      _propertyState.value = s.State<Listing>(loading: true);
      final property = _getListingUseCase.execute(_propertyId.value!);
      final Stream<s.State<Listing>> mappedPropertyState = property.map((event) {
        return s.State<Listing>(content: event);
      }).handleError((onError) {
        _propertyState.value = s.State<Listing>(error: onError);
      });

      _propertyState.bindStream(mappedPropertyState);
    } catch (e) {
      _propertyState.value = s.State<Listing>(
          error: Exception("Could not "
              "get property available state."));
    }
  }

  Rx<s.State<Listing?>> getListing() {
    return _propertyState;
  }

  Listing? getListingValue() {
    return _propertyState.value.content;
  }

  bool isValidConfig() {
    return _propertyState.value.content != null && _getVisitorState.value.content != null;
  }

  void doCheckin() {
    _doCheckInState.value = s.State<bool>(loading: true);
    try {
      final visitor = getVisitor();
      final listerId = _propertyState.value.content?.userId;
      final userId = visitor?.id;
      _doCheckinUseCase.execute(userId!, _propertyId.value!, listerId!, visitor!);
      _analyticsUseCase.execute('checkin', {"listingId": _propertyId});
      _doCheckInState.value = s.State<bool>(content: true);
    } catch (e) {
      _doCheckInState.value = s.State<bool>(error: Exception('$e'));
    }
  }

  Rx<s.State<bool>> getCheckinState() {
    return _checkInState;
  }

  void _getVisitor() {
    try {
      _getVisitorState.value = s.State(loading: true);
      final visitor = _getVisitorUseCase.execute(_getUserId().value!);
      final mappedVisitor = visitor.map((event) => s.State(content: event));

      _getVisitorState.bindStream(mappedVisitor.handleError((onError) => _getVisitorState.value = s.State(error: onError)));
    } catch (e) {
      _getVisitorState.value = s.State(error: Exception("$e"));
    }
  }

  Visitor? getVisitor() {
    return _getVisitorState.value.content;
  }

  @override
  void dispose() {
    try {
      _getPropertySubscription?.cancel();
      getIsCheckedInSubscription?.cancel();
      _getVisitorSubscription?.cancel();

      _checkInState.close();
      _propertyState.close();
    } catch (e) {
      logger.d('Error on dispose streams', e);
    }
    super.dispose();
  }
}

class CheckinLumpedInputData {
  Listing? listing;
  Visitor? visitor;

  CheckinLumpedInputData({this.listing, this.visitor});
}

class GetPropertyLumpedInputData {
  String? userId;
  String? propertyId;

  GetPropertyLumpedInputData({this.userId, this.propertyId});
}
