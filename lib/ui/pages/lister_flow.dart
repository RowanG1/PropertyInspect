import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/controllers_factories.dart';
import 'package:property_inspect/ui/controllers/lister_registration_controller.dart';
import 'package:property_inspect/ui/pages/lister_registration_form.dart';
import 'package:property_inspect/ui/pages/signin_container.dart';
import '../controllers/lister_flow_controller.dart';
import '../controllers/login_controller.dart';

class ListerFlow extends StatelessWidget {
  final Widget body;
  final LoginController _loginController = Get.find();
  final ListerFlowController _listerFlowController = Get.put
    (ListerFlowControllerFactory().make());
  final ListerRegistrationController _listerRegistrationController = Get.put
    (ListerRegistrationControllerFactory().make());

  ListerFlow({required this.body, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => isLoading() ? Text
        ('Loading state') : _loginController.getLoginState().value ? (_listerFlowController
          .getIsListerRegistered() ? body : ListerRegistrationForm()) :
      SignInContainer()),
    );
  }

  bool isLoading() {
    return _listerRegistrationController.isLoading() || _listerFlowController
        .getIsLoading();
  }
}
