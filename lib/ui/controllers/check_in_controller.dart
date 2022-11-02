import 'package:get/get.dart';
import 'package:property_inspect/data/types/optional.dart';
import 'package:property_inspect/domain/entities/visitor.dart';
import 'package:property_inspect/domain/usecase/analytics_use_case.dart';
import 'package:property_inspect/domain/usecase/get_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import '../../domain/entities/listing.dart';
import '../../domain/entities/state.dart' as s;
import '../../domain/usecase/checked_in_use_case.dart';
import '../../domain/usecase/do_checkin_use_case.dart';
import '../../domain/usecase/get_listing_available_use_case.dart';
import '../../domain/usecase/get_visitor_use_case.dart';
import 'package:rxdart/rxdart.dart' as RxRaw;

class CheckinController extends GetxController {
  final CheckedInUseCase _isCheckedInUseCase;
  final GetLoginIdUseCase _getLoginIdUseCase;
  final DoCheckinUseCase _doCheckinUseCase;
  final GetListingUseCase _getListingUseCase;
  final GetVisitorUseCase _getVisitorUseCase;
  final AnalyticsUseCase _analyticsUseCase;

  final Rx<String?> _propertyId = (null as String?).obs;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final Rx<s.State<bool>> _checkInState = s.State<bool>().obs;
  final Rx<s.State<Listing>> _propertyState = s.State<Listing>().obs;
  final Rx<s.State<Optional<bool>>> _isRegisteredState =
      s.State<Optional<bool>>().obs;
  final Rx<s.State<Visitor>> _getVisitorState = s.State<Visitor>().obs;
  final Rx<CheckinLumpedInputData> _checkinCombinedInputs =
      CheckinLumpedInputData().obs;

  CheckinController(
      this._isCheckedInUseCase,
      this._getLoginIdUseCase,
      this._doCheckinUseCase,
      this._getListingUseCase,
      this._getVisitorUseCase,
      this._analyticsUseCase);

  @override
  void onInit() {
    super.onInit();
    final Stream<Optional<String>> loginIdStream = _getLoginIdUseCase.execute();
    _userId.bindStream(loginIdStream.handleError((onError) {
      print("Error on login Id checkin controller $onError");
    }));
    ever(_userId, (value) {
      if (value.value != null) {
        _getVisitor();
      }
    });

    final propertyIdStream = _propertyId.stream;
    final lumpedPropertyInputStream = RxRaw.Rx.combineLatest2(
        propertyIdStream, loginIdStream, (propertyId, loginId) {
      return GetPropertyLumpedInputData(
          propertyId: propertyId, userId: loginId.value);
    });

    lumpedPropertyInputStream.listen((data) {
      if (data.userId != null && data.propertyId != null) {
        _getProperty();
      }
    });

    ever(_checkinCombinedInputs, (value) {
      final visitor = value.visitor;
      final listing = value.listing;
      if (visitor != null && listing != null) {
        _getIsCheckedIn(listing, visitor);
      }
    });

    final combinedCheckinInputs = RxRaw.Rx.combineLatest3(
        _propertyState.stream, _getVisitorState.stream, _userId.stream,
        (property, visitor, userId) {
      return CheckinLumpedInputData(
        listing: property.content,
        visitor: visitor.content,
      );
    });

    _checkinCombinedInputs.bindStream(combinedCheckinInputs);
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
        print('Getting checkin state with userid $visitorId, propertyId '
            '$listingId, lister ID: $listerId');

        _checkInState.value = s.State<bool>(loading: true);
        final isCheckedIn =
            _isCheckedInUseCase.execute(listerId, visitorId, listingId);
        final mappedCheckin =
            isCheckedIn.map((event) => s.State<bool>(content: event));

        _checkInState.bindStream(mappedCheckin.handleError(
            (onError) => _checkInState.value = s.State<bool>(error: onError)));
      }
    } catch (e) {
      _checkInState.value = s.State<bool>(error: Exception("$e"));
    }
  }

  getIsCheckedIn() {
    return _checkInState.value.content == true;
  }

  getIsLoading() {
    return _propertyState.value.loading == true ||
        _checkInState.value.loading == true ||
        _isRegisteredState.value.loading == true;
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
      final Stream<s.State<Listing>> mappedPropertyState =
          property.map((event) {
        return s.State<Listing>(content: event);
      }).handleError((onError) {
        print("get Property OnError:");
        print(onError);
        _propertyState.value = s.State<Listing>(error: onError);
      });

      _propertyState.bindStream(mappedPropertyState);
    } catch (e) {
      print("Get property error");
      print(e);
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
    return _propertyId != null &&
        _propertyState.value.content != null &&
        _getVisitorState.value.content != null;
  }

  void doCheckin() {
    _checkInState.value = s.State<bool>(loading: true);
    try {
      final visitor = getVisitor();
      final listerId = _propertyState.value.content?.userId;
      final userId = visitor?.id;
      _doCheckinUseCase.execute(
          userId!, _propertyId.value!, listerId!, visitor!);
      _analyticsUseCase.execute('checkin', {"listingId": _propertyId});
    } catch (e) {
      print('Check-in error $e');
      _checkInState.value = s.State<bool>(error: Exception('$e'));
    }
  }

  Rx<s.State<bool>> getCheckinState() {
    return _checkInState;
  }

  bool isRegistered() {
    return _isRegisteredState.value.content?.value == true;
  }

  void _getVisitor() {
    try {
      _getVisitorState.value = s.State(loading: true);
      final visitor = _getVisitorUseCase.execute(_getUserId().value!);
      final mappedVisitor = visitor.map((event) => s.State(content: event));

      _getVisitorState.bindStream(mappedVisitor.handleError(
          (onError) => _getVisitorState.value = s.State(error: onError)));
    } catch (e) {
      _getVisitorState.value = s.State(error: Exception("$e"));
    }
  }

  Visitor? getVisitor() {
    return _getVisitorState.value.content;
  }

  @override
  void dispose() {
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
