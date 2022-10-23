import 'package:flutter/cupertino.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';

class SignInContainer extends StatelessWidget {
  final LoginController loginController = Get.find();

  SignInContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SignInScreen(
      providerConfigs: [EmailProviderConfiguration()],
    );
  }
}
