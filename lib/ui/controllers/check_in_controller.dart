import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/types/optional.dart';
import 'package:property_inspect/domain/entities/visitor.dart';
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
  final GetListingAvailableUseCase _listingAvailableUseCase;
  final GetLoginIdUseCase _getLoginIdUseCase;
  final DoCheckinUseCase _doCheckinUseCase;
  final GetListingUseCase _getListingUseCase;
  final GetVisitorUseCase _getVisitorUseCase;

  String? _propertyId;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final Rx<s.State<bool>> _checkInState = s.State<bool>().obs;
  final Rx<s.State<bool>> _propertyAvailableState = s.State<bool>().obs;
  final Rx<s.State<Listing>> _propertyState = s.State<Listing>().obs;
  final Rx<s.State<Optional<bool>>> _isRegisteredState =
      s.State<Optional<bool>>().obs;
  final Rx<s.State<Visitor>> _getVisitorState = s.State<Visitor>().obs;
  Rx<CheckinLumpedInputData> _checkinCombinedInputs = CheckinLumpedInputData().obs;

  CheckinController(
      this._isCheckedInUseCase,
      this._listingAvailableUseCase,
      this._getLoginIdUseCase,
      this._doCheckinUseCase,
      this._getListingUseCase,
      this._getVisitorUseCase);

  @override
  void onInit() {
    super.onInit();
    final Stream<Optional<String>> loginIdStream = _getLoginIdUseCase.execute();
    _userId.bindStream(loginIdStream);
    ever(_userId, (value) {
      if (value.value != null) {
        _getVisitor();
      }
    });

    ever(_checkinCombinedInputs, (value) {
      final userId = value.userId;
      final visitor = value.visitor;
      final listing = value.listing;
      if (visitor != null && listing != null && userId !=
          null) {
        _getIsCheckedIn(userId, listing, visitor);
      }
    });

    ever(_checkInState, (value) {
      if (value.error != null) {
        Get.snackbar("Error", value.error.toString(), backgroundColor: Colors.red);
      }
    });

    final combinedCheckinInputs = RxRaw.Rx.combineLatest3(
        _propertyState.stream, _getVisitorState.stream, _userId.stream,
            (property, visitor, userId) {
          return CheckinLumpedInputData(
              listing: property.content,
              visitor: visitor.content,
              userId: userId.value);
        });

    _checkinCombinedInputs.bindStream(combinedCheckinInputs);
  }

  Optional<String> _getUserId() {
    return _userId.value;
  }

  _getIsCheckedIn(String userId, Listing listing, Visitor visitor) {
    try {
      final listingId = listing.id!;
      final listerId = listing.userId;
      print('Getting checkin state with userid $userId, propertyId '
          '$listingId, lister ID: $listerId');

      _checkInState.value = s.State<bool>(loading: true);
      final isCheckedIn = _isCheckedInUseCase.execute(
          listerId, _getUserId().value!, _propertyId!);
      final mappedCheckin =
          isCheckedIn.map((event) => s.State<bool>(content: event));

      _checkInState.bindStream(mappedCheckin.handleError(
          (onError) => _checkInState.value = s.State<bool>(error: onError)));
    } catch (e) {
      _checkInState.value = s.State<bool>(error: Exception("$e"));
    }
  }

  getIsCheckedIn() {
    return _checkInState.value.content == true;
  }

  getIsLoading() {
    return _propertyAvailableState.value.loading == true ||
        _checkInState.value.loading == true ||
        _isRegisteredState.value.loading == true;
  }

  void setPropertyId(String? propertyId) {
    _propertyId = propertyId;
    if (propertyId != null) {
      _getPropertyIsAvailable();
      _getProperty();
    }
  }

  String? getPropertyId() {
    return _propertyId;
  }

  _getPropertyIsAvailable() {
    try {
      _propertyAvailableState.value = s.State<bool>(loading: true);
      final isAvailable = _listingAvailableUseCase.execute(_propertyId!);
      final Stream<s.State<bool>> mappedPropertyAvailableState =
          isAvailable.map<s.State<bool>>((event) {
        return s.State<bool>(content: event);
      });

      _propertyAvailableState.bindStream(
          mappedPropertyAvailableState.handleError((onError) =>
              _propertyAvailableState.value = s.State<bool>(error: onError)));
    } catch (e) {
      print(e);
      _propertyAvailableState.value = s.State<bool>(
          error: Exception("Could not "
              "get property available state."));
    }
  }

  _getProperty() {
    try {
      _propertyState.value = s.State<Listing>(loading: true);
      final property = _getListingUseCase.execute(_propertyId!);
      final Stream<s.State<Listing>> mappedPropertyState = property.map((event) {
        return s.State<Listing>(content: event);
      }).handleError((onError) {
        print("OnError:");
        print(onError);
        _propertyState.value = s.State<Listing>(error: onError);
      });

      _propertyState.bindStream(mappedPropertyState);
    } catch (e) {
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
        _propertyAvailableState.value.content == true &&
        _propertyState.value.content != null &&
        _getVisitorState.value.content != null;
  }

  Rx<s.State<bool>> propertyIsAvailable() {
    return _propertyAvailableState;
  }

  void doCheckin() {
    _checkInState.value = s.State<bool>(loading: true);
    try {
      final visitor = getVisitor();
      final listerId = _propertyState.value.content?.userId;
      final userId = _getUserId().value;
      _doCheckinUseCase.execute(userId!, _propertyId!, listerId!, visitor!);
    } catch (e) {
      print('Check-in error $e');
      _checkInState.value = s.State<bool>(error: Exception('$e'));
    }
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
}

class CheckinLumpedInputData {
  Listing? listing;
  Visitor? visitor;
  String? userId;

  CheckinLumpedInputData({this.listing, this.visitor, this.userId});
}
