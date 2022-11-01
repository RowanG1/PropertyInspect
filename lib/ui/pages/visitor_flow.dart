import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/controllers_factories.dart';
import 'package:property_inspect/ui/controllers/lister_registration_controller.dart';
import 'package:property_inspect/ui/controllers/visitor_registration_controller.dart';
import 'package:property_inspect/ui/pages/lister_registration_form.dart';
import 'package:property_inspect/ui/pages/signin_container.dart';
import 'package:property_inspect/ui/pages/visitor_registration_form.dart';
import 'package:property_inspect/ui/widgets/page_with_footer.dart';
import '../../data/types/env.dart';
import '../../domain/constants.dart';
import '../controllers/lister_flow_controller.dart';
import '../controllers/login_controller.dart';
import '../controllers/visitor_flow_controller.dart';

class VisitorFlow extends StatefulWidget {
  final Widget body;
  final String? pageTitle;

  VisitorFlow({required this.body, this.pageTitle, Key? key}) : super(key: key);

  @override
  State<VisitorFlow> createState() => _VisitorFlowState();
}

class _VisitorFlowState extends State<VisitorFlow> {
  final LoginController _loginController = Get.find();

  final VisitorFlowController _visitorFlowController =
      Get.find();

  final VisitorRegistrationController _visitorRegistrationController =
      Get.put(VisitorRegistrationControllerFactory().make());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ever(_visitorFlowController.getIsVisitorRegisteredRx(), (value) {
        if (value.error != null) {
          Get.snackbar("Error", value.error.toString(),
              backgroundColor: Colors.red);
        }
      });

      ever(_visitorRegistrationController.getCreateState(), (value) {
        if (value.error != null) {
          Get.snackbar("Error", value.error.toString(),
              backgroundColor: Colors.red);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text(widget.pageTitle ?? ""),
            actions: [IconButton(
              icon: Icon(Icons.home),
              color: Colors.white,
              onPressed: () {
                Get.offAllNamed(Constants.homeRoute);
              },
            )]),
        body: PageWithFooter(
          body: Obx(() => isLoading()
                ? Center(
                  child: CircularProgressIndicator(
                      value: null,
                      semanticsLabel: 'Circular progress indicator',
                    ),
                )
                : _loginController.getLoginState().value
                    ? (_visitorFlowController.getIsVisitorRegistered()
                        ? widget.body
                        : VisitorRegistrationForm())
                    : SignInContainer(),
          ),
        ),
      ),
    );
  }

  bool isLoading() {
    return _visitorRegistrationController.isLoading() ||
        _visitorFlowController.getIsLoading();
  }
}
