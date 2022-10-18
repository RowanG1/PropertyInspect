import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/pages/signin_container.dart';

class ResumeAfterAuthenticatedPage extends StatelessWidget {
  final Widget body;
  final LoginController loginController = Get.find();

  ResumeAfterAuthenticatedPage({required this.body, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() =>
          loginController.getLoginState().value ? body : SignInContainer()),
    );
  }
}
