import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:property_inspect/domain/entities/check_in_state.dart';
import 'package:property_inspect/domain/entities/optional.dart';
import 'package:property_inspect/domain/usecase/get_is_visitor_registerd_use_case.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import '../../domain/entities/property_available_state.dart';
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

  String? _propertyId;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final Rx<CheckInState> _checkInState = CheckInState().obs;
  final Rx<PropertyAvailableState> _propertyAvailableState =
      PropertyAvailableState().obs;
  final Rx<State<Optional<bool>>> _isRegisteredState = State<Optional<bool>>()
      .obs;

  CheckinController(this._isCheckedInUseCase, this._listingAvailableUseCase,
      this._getLoginIdUseCase, this._doCheckinUseCase, this._isVisitorRegisteredUseCase);

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
      _checkInState.value = CheckInState(loading: true);
      final isCheckedIn =
          _isCheckedInUseCase.execute(_getUserId().value!, _propertyId!);
      final mappedCheckin =
          isCheckedIn.map((event) => CheckInState(content: event));

      _checkInState.bindStream(mappedCheckin.handleError(
          (onError) => _checkInState.value = CheckInState(error: onError)));
    } catch (e) {
      _checkInState.value = CheckInState(error: Exception("$e"));
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
      _getIsCheckedIn();
    }
  }

  String? getPropertyId() {
    return _propertyId;
  }

  _getPropertyIsAvailable() {
    try {
      _propertyAvailableState.value = PropertyAvailableState(loading: true);
      final isAvailable = _listingAvailableUseCase.execute(_propertyId!);
      final Stream<PropertyAvailableState> mappedPropertyAvailableState =
          isAvailable.map<PropertyAvailableState>((event) {
        return PropertyAvailableState(content: event);
      });

      _propertyAvailableState.bindStream(mappedPropertyAvailableState
          .handleError((onError) => _propertyAvailableState.value =
              PropertyAvailableState(error: onError)));
    } catch (e) {
      print(e);
      _propertyAvailableState.value = PropertyAvailableState(
          error: Exception("Could not "
              "get property available state."));
    }
  }

  bool isValidConfig() {
    return _propertyId != null && _propertyAvailableState.value.content == true;
  }

  Rx<PropertyAvailableState> propertyIsAvailable() {
    return _propertyAvailableState;
  }

  void doCheckin() {
    print('Doing checkin');
    _checkInState.value = CheckInState(loading: true);
    try {
      _doCheckinUseCase.execute(_getUserId().value!, _propertyId!);
    } catch (e) {
      print('Woops, error $e');
      _checkInState.value = CheckInState(error: Exception('$e'));
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
