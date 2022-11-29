import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:property_inspect/application/usecase/create_listing_use_case.dart';
import 'package:property_inspect/application/usecase/get_login_id_use_case.dart';
import '../../data/types/optional.dart';
import '../../application/usecase/analytics_use_case.dart';
import '../../data/utils/field_validation.dart';
import '../../data/types/state.dart' as s;

class CreateListingController extends GetxController {
  final Rx<s.State<bool>> _state = s.State<bool>().obs;
  CreateListingUseCase _createListingUseCase;
  final AnalyticsUseCase _analyticsUseCase;
  final GetLoginIdUseCase _getLoginIdUseCase;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  FieldValidation validation = FieldValidation();
  final Logger _logger = Get.find();

  CreateListingController(this._createListingUseCase, this._getLoginIdUseCase, this._analyticsUseCase);

  @override
  void onInit() {
    super.onInit();
    _userId.bindStream(_getLoginIdUseCase.execute());
  }

  final addressController = TextEditingController();
  final suburbController = TextEditingController();
  final postCodeController = TextEditingController();
  final phoneController = TextEditingController();

  createListing() async {
    final address = addressController.value.text;
    final suburb = suburbController.value.text;
    final postCode = postCodeController.value.text;
    final phone = phoneController.value.text;

    final loginId = _userId.value.value;
    if (loginId != null) {
      _state.value = s.State(loading: true);
      try {
        await _createListingUseCase.execute(loginId, address, suburb, postCode, phone);
        _state.value = s.State(content: true);
        _analyticsUseCase.execute('create_listing', {});
      } catch (e) {
        _state.value = s.State(error: Exception('$e'));
      }
    }
  }

  validate(TextEditingController controller) {
    return validation.getNonEmptyValidation(controller.text);
  }

  bool getIsLoading() {
    return _state.value.loading;
  }

  Rx<s.State<bool>> getCreateState() {
    return _state;
  }

  @override
  void dispose() {
    try {
      _state.close();
    } catch (e) {
      _logger.d("Dispose subscription error", e);
    }
    super.dispose();
  }
}
