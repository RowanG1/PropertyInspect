import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import '../../data/types/optional.dart';
import '../../domain/usecase/create_visitor_registration_use_case.dart';
import '../../domain/utils/field_validation.dart';
import 'package:property_inspect/domain/entities/state.dart' as s;

class VisitorRegistrationController extends GetxController {
  CreateVisitorRegistrationUseCase visitorRegistration;
  GetLoginIdUseCase _loginIdUseCase;
  FieldValidation validation = FieldValidation();
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final Rx<s.State<bool>> _createState = s.State<bool>().obs;

  VisitorRegistrationController(this.visitorRegistration, this._loginIdUseCase);

  @override
  void onInit() {
    super.onInit();
    _userId.bindStream(_loginIdUseCase.execute());

    ever(_createState, (value) {
      if (value.error != null) {
        Get.snackbar("Error", value.error.toString(), backgroundColor: Colors.red);
      }
    });
  }

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final suburbController = TextEditingController();

  createUser() async {
    final userId = _getUserId().value;
    if (userId != null) {
      final name = nameController.value.text;
      final lastName = lastNameController.value.text;
      final email = emailController.value.text;
      final phone = phoneController.value.text;
      final suburb = suburbController.value.text;

      _createState.value = s.State(loading: true);
      try {
        await visitorRegistration.execute(userId, name, lastName, email, phone,
            suburb);
        _createState.value = s.State(content: true);
      } catch(e) {
        _createState.value = s.State(error: Exception('$e'));
      }
    }
  }

  String? validate(TextEditingController controller) {
    if (controller == emailController) {
      return validation.getEmailValidation(controller.text);
    } else {
      return validation.getNonEmptyValidation(
          controller.text);
    }
  }

  Optional<String> _getUserId() {
    return _userId.value;
  }

  bool isLoading() {
    return _createState.value.loading;
  }
}
