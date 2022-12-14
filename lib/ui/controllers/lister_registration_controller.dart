import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:property_inspect/data/types/state.dart' as s;
import 'package:property_inspect/application/usecase/analytics_use_case.dart';
import 'package:property_inspect/application/usecase/create_lister_registration.dart';
import 'package:property_inspect/application/usecase/get_login_id_use_case.dart';
import '../../data/types/optional.dart';
import '../../domain/entities/lister.dart';
import '../../data/utils/field_validation.dart';

class ListerRegistrationController extends GetxController {
  final CreateListerRegistrationUseCase _listerRegistrationUseCase;
  final GetLoginIdUseCase _loginIdUseCase;
  final AnalyticsUseCase _analyticsUseCase;
  FieldValidation _validation = FieldValidation();
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final Rx<s.State<bool>> _createListerState = s.State<bool>().obs;
  final Logger _logger = Get.find();

  ListerRegistrationController(this._listerRegistrationUseCase, this._loginIdUseCase, this._analyticsUseCase);

  @override
  void onInit() {
    super.onInit();
    _userId.bindStream(_loginIdUseCase.execute());
  }

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final companyController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  createRegistration() async {
    final userId = _getUserId().value;
    if (userId != null) {
      final agentName = nameController.value.text;
      final lastName = lastNameController.value.text;
      final company = companyController.value.text;
      final email = emailController.value.text;
      final phone = phoneController.value.text;
      final lister = Lister(id: userId, name: agentName, lastName: lastName, company: company, email: email, phone: phone);

      _createListerState.value = s.State(loading: true);
      try {
        await _listerRegistrationUseCase.execute(lister);
        _createListerState.value = s.State(content: true);
        _analyticsUseCase.execute('register_lister', {});
      } catch (e) {
        _createListerState.value = s.State(error: Exception('$e'));
      }
    }
  }

  String? validate(TextEditingController controller) {
    if (controller == emailController) {
      return _validation.getEmailValidation(controller.text);
    } else {
      return _validation.getNonEmptyValidation(controller.text);
    }
  }

  getCheckboxValidator() {
    return _validation.getCheckboxValidation;
  }

  Optional<String> _getUserId() {
    return _userId.value;
  }

  bool isLoading() {
    return _createListerState.value.loading;
  }

  Rx<s.State<bool>> getCreateListerState() {
    return _createListerState;
  }

  @override
  void dispose() {
    try {
      _createListerState.close();
    } catch (e) {
      _logger.d("Dispose streams error", e);
    }
    super.dispose();
  }
}
