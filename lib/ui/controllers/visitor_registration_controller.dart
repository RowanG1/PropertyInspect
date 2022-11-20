import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/usecase/analytics_use_case.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import '../../data/types/optional.dart';
import '../../domain/usecase/create_visitor_registration_use_case.dart';
import '../../domain/utils/field_validation.dart';
import 'package:property_inspect/domain/entities/state.dart' as s;

class VisitorRegistrationController extends GetxController {
  CreateVisitorRegistrationUseCase visitorRegistration;
  final GetLoginIdUseCase _loginIdUseCase;
  final AnalyticsUseCase _analyticsUseCase;
  FieldValidation validation = FieldValidation();
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final Rx<s.State<bool>> _createState = s.State<bool>().obs;

  VisitorRegistrationController(this.visitorRegistration, this
      ._loginIdUseCase, this._analyticsUseCase);

  @override
  void onInit() {
    super.onInit();
    _userId.bindStream(_loginIdUseCase.execute());
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
        _analyticsUseCase.execute('register_visitor', {});
      } catch (e) {
        _createState.value = s.State(error: Exception('$e'));
        _analyticsUseCase.execute("create_visitor_error", {'error': e});
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

  getCheckboxValidator() {
    return validation.getCheckboxValidation;
  }

  Optional<String> _getUserId() {
    return _userId.value;
  }

  bool isLoading() {
    return _createState.value.loading;
  }

  Rx<s.State<bool>> getCreateState() {
    return _createState;
  }

  @override
  void dispose() {
    _createState.close();
    super.dispose();
  }
}
