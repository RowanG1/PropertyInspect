import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/usecase/create_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import '../../data/types/optional.dart';
import '../../domain/constants.dart';
import '../../domain/utils/field_validation.dart';
import '../../domain/entities/state.dart' as s;

class CreateListingController extends GetxController {
  final Rx<s.State<bool>> _state = s.State<bool>().obs;
  CreateListingUseCase createListingUseCase;
  GetLoginIdUseCase _getLoginIdUseCase;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  FieldValidation validation = FieldValidation();

  CreateListingController(this.createListingUseCase, this._getLoginIdUseCase);

  @override
  void onInit() {
    super.onInit();
    _userId.bindStream(_getLoginIdUseCase.execute());

    ever(_state, (value) {
      if (value.content == true) {
        Get.toNamed(Constants.listingsRoute);
      }
      if (value.error != null) {
        Get.snackbar("Error", value.error.toString(), backgroundColor: Colors.red);
      }
    });
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
        await createListingUseCase.execute(
            loginId, address, suburb, postCode, phone);
        _state.value = s.State(content: true);
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
}
