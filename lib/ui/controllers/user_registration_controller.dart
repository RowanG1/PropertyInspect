import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../data/usecase/create_visitor_registration.dart';

class VisitorRegistrationController extends GetxController {
  CreateVisitorRegistrationUseCase visitorRegistration;

  VisitorRegistrationController(this.visitorRegistration);

  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  createUser() {
    final email = emailController.value.text;
    final phone = phoneController.value.text;
    visitorRegistration.execute(email, phone);
  }
}
