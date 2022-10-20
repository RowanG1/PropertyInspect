import 'package:flutter/cupertino.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';

class SignInRouteHome extends StatelessWidget {
  final LoginController loginController = Get.find();

  SignInRouteHome({Key? key}) : super(key: key) {
    loginController.getLoginState().listen((isLoggedIn) {
      if (isLoggedIn) {
        Get.toNamed(Constants.homeRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SignInScreen(
      providerConfigs: [EmailProviderConfiguration()],
    );
  }
}
