import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/pages/signin_container.dart';
import '../../domain/constants.dart';
import '../controllers/login_controller.dart';

class ResumeAfterAuthenticatedPage extends StatelessWidget {
  final Widget body;
  final String? continuePage;

  const ResumeAfterAuthenticatedPage({required this.body, this.continuePage,
    Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();
    loginController.loginCompletionGoToRoute = continuePage;

    return Scaffold(
      body: Obx(() =>
      loginController.getLoginState().value ? body : const SignInContainer
        ()),
    );
  }
}