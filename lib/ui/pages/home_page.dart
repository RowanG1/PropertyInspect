import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/constants.dart';

import '../controllers/login_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    return Column(children: [
      TextButton(
        onPressed: () {
          loginController.logout();
        },
        child: const Text("Click to log out"),
      ),
      TextButton(
        onPressed: () {
          Get.toNamed(Constants.userRegistrationRoute);
        },
        child: const Text("User registration"),
      ),
      TextButton(
        onPressed: () {
          Get.toNamed(Constants.signInRoute, arguments: {'myPlace': 'good'});
        },
        child: const Text("User sign up - continue flow"),
      )
    ]);
  }
}
