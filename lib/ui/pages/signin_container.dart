import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/controllers/test_mode_controller.dart';

class SignInContainer extends StatelessWidget {
  const SignInContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TestModeController testModelController = Get.find();
    return Obx(() => (!testModelController.isTestMode.value) ? const SignInScreen() : const Text('Sign in page'));
  }
}
