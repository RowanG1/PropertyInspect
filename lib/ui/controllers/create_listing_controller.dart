import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/usecase/create_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import '../../data/types/optional.dart';
import '../../domain/utils/field_validation.dart';

class CreateListingController extends GetxController {
  CreateListingUseCase createListingUseCase;
  GetLoginIdUseCase _getLoginIdUseCase;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  FieldValidation validation = FieldValidation();

  CreateListingController(this.createListingUseCase, this._getLoginIdUseCase);

  @override
  void onInit() {
    super.onInit();
    _userId.bindStream(_getLoginIdUseCase.execute());
  }

  final addressController = TextEditingController();
  final suburbController = TextEditingController();
  final postCodeController = TextEditingController();
  final phoneController = TextEditingController();

  createListing() {
    final address = addressController.value.text;
    final suburb = suburbController.value.text;
    final postCode = postCodeController.value.text;
    final phone = phoneController.value.text;

    final loginId = _userId.value.value;
    if (loginId != null) {
      createListingUseCase.execute(loginId, address, suburb, postCode, phone);
    }
  }

  validate(TextEditingController controller) {
    return validation.getNonEmptyValidation(
        controller.text);
  }
}
