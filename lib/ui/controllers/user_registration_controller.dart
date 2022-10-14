import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../data/usecase/create_visitor_registration.dart';

class VisitorRegistrationController extends GetxController {
  CreateVisitorRegistrationUseCase visitorRegistration;

  VisitorRegistrationController(this.visitorRegistration);

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final suburbController = TextEditingController();

  createUser() {
    final name = nameController.value.text;
    final lastName = lastNameController.value.text;
    final email = emailController.value.text;
    final phone = phoneController.value.text;
    final suburb = suburbController.value.text;

    visitorRegistration.execute(name, lastName, email, phone, suburb);
  }
}
