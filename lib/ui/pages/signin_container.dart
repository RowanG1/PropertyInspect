import 'package:flutter/cupertino.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/ui/controllers/continue_referrer_controller.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';

class SignInContainer extends StatelessWidget {
  final LoginController loginController = Get.find();
  final referrerController = Get.find<ContinueReferrerController>();

  SignInContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setupRouteAfterLogin();

    return const SignInScreen(
      providerConfigs: [EmailProviderConfiguration()],
    );
  }

  setupRouteAfterLogin() {
    loginController.getLoginState().listen((val) {
      if (val) {
        try {
          print("Going to referrer route");
          Get.toNamed(referrerController.referrerRoute!);
        } catch (e) {
          print("Error:");
          print(e);
          Get.toNamed(Constants.homeRoute);
          return;
        }
      }
    });
  }
}
