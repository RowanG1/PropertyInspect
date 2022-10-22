import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:property_inspect/domain/entities/optional.dart';
import 'package:property_inspect/domain/usecase/get_is_visitor_registerd_use_case.dart';
import 'package:property_inspect/domain/usecase/get_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import '../../domain/entities/listing.dart';
import '../../domain/entities/state.dart';
import '../../domain/usecase/checked_in_use_case.dart';
import '../../domain/usecase/do_checkin_use_case.dart';
import '../../domain/usecase/get_listing_available_use_case.dart';

class CheckinController extends GetxController {
  final CheckedInUseCase _isCheckedInUseCase;
  final GetListingAvailableUseCase _listingAvailableUseCase;
  final GetLoginIdUseCase _getLoginIdUseCase;
  final DoCheckinUseCase _doCheckinUseCase;
  final GetIsVisitorRegisteredUseCase _isVisitorRegisteredUseCase;
  final GetListingUseCase _getListingUseCase;

  String? _propertyId;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final Rx<State<bool>> _checkInState = State<bool>().obs;
  final Rx<State<bool>> _propertyAvailableState =
      State<bool>().obs;
  final Rx<State<Listing>> _propertyState =
      State<Listing>().obs;
  final Rx<State<Optional<bool>>> _isRegisteredState = State<Optional<bool>>()
      .obs;

  CheckinController(this._isCheckedInUseCase, this._listingAvailableUseCase,
      this._getLoginIdUseCase, this._doCheckinUseCase, this
          ._isVisitorRegisteredUseCase, this._getListingUseCase);

  @override
  void onInit() {
    super.onInit();
    final Stream<Optional<String>> loginIdStream = _getLoginIdUseCase.execute();
    _userId.bindStream(loginIdStream);

    ever(_userId, (value) {
      if (value.value != null) {
        _getIsCheckedIn();
        _checkIsRegistered();
      }
    });
  }

  Optional<String> _getUserId() {
    return _userId.value;
  }

  _getIsCheckedIn() {
    try {
      final userId = _getUserId().value;
      print('Getting checkin state with userid $userId, propertyId '
          '$_propertyId');
      _checkInState.value = State<bool>(loading: true);
      final isCheckedIn =
          _isCheckedInUseCase.execute(_getUserId().value!, _propertyId!);
      final mappedCheckin =
          isCheckedIn.map((event) => State<bool>(content: event));

      _checkInState.bindStream(mappedCheckin.handleError(
          (onError) => _checkInState.value = State<bool>(error: onError)));
    } catch (e) {
      _checkInState.value = State<bool>(error: Exception("$e"));
    }
  }

  getIsCheckedIn() {
    return _checkInState.value.content;
  }

  getIsLoading() {
    return _propertyAvailableState.value.loading || _checkInState.value
        .loading || _isRegisteredState.value.loading;
  }

  void setPropertyId(String? propertyId) {
    _propertyId = propertyId;
    if (propertyId != null) {
      _getPropertyIsAvailable();
      _getProperty();
      _getIsCheckedIn();
    }
  }

  String? getPropertyId() {
    return _propertyId;
  }

  _getPropertyIsAvailable() {
    try {
      _propertyAvailableState.value = State<bool>(loading: true);
      final isAvailable = _listingAvailableUseCase.execute(_propertyId!);
      final Stream<State<bool>> mappedPropertyAvailableState =
          isAvailable.map<State<bool>>((event) {
        return State<bool>(content: event);
      });

      _propertyAvailableState.bindStream(mappedPropertyAvailableState
          .handleError((onError) => _propertyAvailableState.value =
              State<bool>(error: onError)));
    } catch (e) {
      print(e);
      _propertyAvailableState.value = State<bool>(
          error: Exception("Could not "
              "get property available state."));
    }
  }

  _getProperty() {
    try {
      _propertyState.value = State<Listing>(loading: true);
      final isAvailable = _getListingUseCase.execute(_propertyId!);
      final Stream<State<Listing>> mappedPropertyAvailableState =
      isAvailable.map<State<Listing>>((event) {
        return State<Listing>(content: event);
      });

      _propertyState.bindStream(mappedPropertyAvailableState
          .handleError((onError) => _propertyState.value =
          State<Listing>(error: onError)));
    } catch (e) {
      print(e);
      _propertyState.value = State<Listing>(
          error: Exception("Could not "
              "get property available state."));
    }
  }

  Rx<State<Listing?>> getListing() {
    return  _propertyState;
  }

  bool isValidConfig() {
    return _propertyId != null && _propertyAvailableState.value.content == true;
  }

  Rx<State<bool>> propertyIsAvailable() {
    return _propertyAvailableState;
  }

  void doCheckin() {
    print('Doing checkin');
    _checkInState.value = State<bool>(loading: true);
    try {
      _doCheckinUseCase.execute(_getUserId().value!, _propertyId!);
    } catch (e) {
      print('Woops, error $e');
      _checkInState.value = State<bool>(error: Exception('$e'));
    }
  }

  void _checkIsRegistered() {
    try {
      final userId = _getUserId().value;
      print('Getting is registered state with userid $userId');
      _isRegisteredState.value = State(loading: true);
      final isRegistered =
      _isVisitorRegisteredUseCase.execute(_getUserId().value!);
      final mappedRegistration =
      isRegistered.map((event) => State(content: event));

      _isRegisteredState.bindStream(mappedRegistration.handleError(
              (onError) => _isRegisteredState.value = State(error: onError)));
    } catch (e) {
      _isRegisteredState.value = State(error: Exception("$e"));
    }
  }

  bool isRegistered() {
    return _isRegisteredState.value.content?.value == true;
  }
}
