import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/usecase/create_listing_use_case.dart';
import '../../domain/constants.dart';
import '../../domain/utils/field_validation.dart';

class CreateListingController extends GetxController {
  CreateListingUseCase createListingUseCase;
  FieldValidation validation = FieldValidation();

  CreateListingController(this.createListingUseCase);

  final addressController = TextEditingController();
  final suburbController = TextEditingController();
  final postCodeController = TextEditingController();
  final phoneController = TextEditingController();

  createListing() {
    final address = addressController.value.text;
    final suburb = suburbController.value.text;
    final postCode = postCodeController.value.text;
    final phone = phoneController.value.text;

    createListingUseCase.execute(address, suburb, postCode, phone);
  }

  validate(TextEditingController controller) {
    return validation.getNonEmptyValidation(
        controller.text);
  }
}
