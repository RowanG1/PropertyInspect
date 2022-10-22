import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/ui/controllers/sign_in_route_home_controller.dart';
import '../../data/di/controllers_builders.dart';

class SignInRouteHome extends StatelessWidget {
  final SigninRouteHomeController controller = Get.put
    (SigninRouteHomeControllerBuilder().make());

  SignInRouteHome({Key? key}) : super(key: key);

  late StreamSubscription<bool> loggedInListener;

  @override
  Widget build(BuildContext context) {
    return FocusDetector(onVisibilityGained: () {
      loggedInListener = controller.getIsLoggedIn().listen((p0) {
        if (p0) {
          Get.offAllNamed(Constants.homeRoute);
        }
      });
    }, onVisibilityLost: () {
      loggedInListener.cancel();
    }, child: const SignInScreen(
      providerConfigs: [EmailProviderConfiguration()],
    ));
  }

}
