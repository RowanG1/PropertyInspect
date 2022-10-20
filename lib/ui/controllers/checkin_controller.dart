import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:property_inspect/domain/entities/checkin_state.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import '../../domain/entities/property_available_state.dart';
import '../../domain/usecase/checked_in_use_case.dart';
import '../../domain/usecase/do_checkin_use_case.dart';
import '../../domain/usecase/get_listing_available_use_case.dart';

class CheckinController extends GetxController {
  final CheckedInUseCase _isCheckedInUseCase;
  final GetListingAvailableUseCase _listingAvailableUseCase;
  final GetLoginIdUseCase _getLoginIdUseCase;
  final DoCheckinUseCase _doCheckinUseCase;

  String? _propertyId;
  final Rx<CheckinState> _checkinState = CheckinState().obs;
  final Rx<PropertyAvailableState> _propertyAvailableState = PropertyAvailableState
    ().obs;

  CheckinController(this._isCheckedInUseCase,
      this._listingAvailableUseCase, this._getLoginIdUseCase, this._doCheckinUseCase) {
    print('Setting user id $_getUserId()');
    _getIsCheckedIn();
  }

  String? _getUserId() {
    return _getLoginIdUseCase.execute();
  }

  _getIsCheckedIn() {
    try {
      _checkinState.value = CheckinState(loading: true);
      final isCheckedIn = _isCheckedInUseCase.execute(_getUserId()!, _propertyId!);
      final mappedCheckin = isCheckedIn.map((event) =>
          CheckinState(content: event));

      _checkinState.bindStream(mappedCheckin.handleError((onError) => _checkinState
          .value =
          CheckinState(error: onError)));
    } catch(e) {
      _checkinState.value = CheckinState(error: Exception("$e"));
    }
  }

  getIsCheckedIn() {
    return _checkinState.value.content;
  }

  getIsLoading() {
    return _propertyAvailableState.value.loading || _checkinState.value.loading;
  }

  void setPropertyId(String? propertyId) {
    _propertyId = propertyId;
    if (propertyId != null) {
      _getPropertyIsAvailable();
    }
  }

  String? getPropertyId() {
    return _propertyId;
  }

  _getPropertyIsAvailable() {
    try {
      _propertyAvailableState.value = PropertyAvailableState(loading: true);
      final isAvailable = _listingAvailableUseCase.execute(_propertyId!);
      final Stream<PropertyAvailableState> mappedPropertyAvailableState = isAvailable
          .map<PropertyAvailableState>((event) {
          return PropertyAvailableState(content: event);});

      _propertyAvailableState.bindStream(mappedPropertyAvailableState
          .handleError((onError) => _propertyAvailableState.value =
          PropertyAvailableState(error: onError)));
    } catch(e) {
      print(e);
      _propertyAvailableState.value = PropertyAvailableState(error: Exception("Could not "
          "get property available state."));
    }
  }
  bool isValidConfig() {
    return _propertyId != null &&
        _propertyAvailableState.value.content == true;
  }

  Rx<PropertyAvailableState> propertyIsAvailable() {
    return _propertyAvailableState;
  }

  void doCheckin() {
    print('Doing checkin');
    _checkinState.value = CheckinState(loading: true);
    try {
      _doCheckinUseCase.execute(_getUserId()!, _propertyId!);
    } catch(e) {
      print('Woops, error $e');
      _checkinState.value = CheckinState(error: Exception('$e'));
    }
  }
}
