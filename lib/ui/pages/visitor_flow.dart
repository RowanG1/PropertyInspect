import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/controllers_factories.dart';
import 'package:property_inspect/ui/controllers/lister_registration_controller.dart';
import 'package:property_inspect/ui/controllers/visitor_registration_controller.dart';
import 'package:property_inspect/ui/pages/lister_registration_form.dart';
import 'package:property_inspect/ui/pages/signin_container.dart';
import 'package:property_inspect/ui/pages/visitor_registration_form.dart';
import '../controllers/lister_flow_controller.dart';
import '../controllers/login_controller.dart';
import '../controllers/visitor_flow_controller.dart';

class VisitorFlow extends StatelessWidget {
  final Widget body;
  final LoginController _loginController = Get.find();
  final VisitorFlowController _visitorFlowController = Get.put
    (VisitorFlowControllerFactory().make());
  final VisitorRegistrationController _visitorRegistrationController = Get.put
    (VisitorRegistrationControllerFactory().make());

  VisitorFlow({required this.body, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => isLoading() ? Text
        ('Loading state') : _loginController.getLoginState().value ? (_visitorFlowController
          .getIsVisitorRegistered() ? body : VisitorRegistrationForm()) :
      SignInContainer()),
    );
  }

  bool isLoading() {
    return _visitorRegistrationController.isLoading() || _visitorFlowController
        .getIsLoading();
  }
}
