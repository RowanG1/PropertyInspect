import 'package:flutter/cupertino.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/controllers/sign_in_route_home_controller.dart';

import '../../data/di/controllers_builders.dart';

class SignInRouteHome extends StatelessWidget {
  final SigninRouteHomeController controller = Get.put
    (SigninRouteHomeControllerBuilder().make());

  SignInRouteHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SignInScreen(
      providerConfigs: [EmailProviderConfiguration()],
    );
  }

}
