import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/controllers_factories.dart';
import 'package:property_inspect/ui/controllers/lister_registration_controller.dart';
import 'package:property_inspect/ui/pages/lister_registration_form.dart';
import 'package:property_inspect/ui/pages/signin_container.dart';
import '../../data/types/env.dart';
import '../../domain/constants.dart';
import '../controllers/lister_flow_controller.dart';
import '../controllers/login_controller.dart';

class ListerFlow extends StatefulWidget {
  final Widget body;

  ListerFlow({required this.body, Key? key}) : super(key: key);

  @override
  State<ListerFlow> createState() => _ListerFlowState();
}

class _ListerFlowState extends State<ListerFlow> {
  final LoginController _loginController = Get.find();
  final ListerFlowController _listerFlowController = Get.find();
  final ListerRegistrationController _listerRegistrationController =
      Get.put(ListerRegistrationControllerFactory().make());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ever(_listerFlowController.getIsListerRegisteredRx(), (value) {
        if (value.error != null) {
          Get.snackbar("Error", value.error.toString(),
              backgroundColor: Colors.red);
        }
      });

      ever(_listerRegistrationController.getCreateListerState(), (value) {
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
            title: Obx(() => Text(_listerFlowController.currentPage.value ?? "")), actions: [IconButton(
          icon: Icon(Icons.home),
          color: Colors.white,
          onPressed: () {
            Get.toNamed(Constants.homeRoute);
          },
        )],
            ),
        body: Obx(() => isLoading()
            ? Center(
              child: CircularProgressIndicator(
                  value: null,
                  semanticsLabel: 'Circular progress indicator',
                ),
            )
            : _loginController.getLoginState().value
                ? (_listerFlowController.getIsListerRegistered()
                    ? widget.body
                    : ListerRegistrationForm())
                : SignInContainer()),
      ),
    );
  }

  bool isLoading() {
    return _listerRegistrationController.isLoading() ||
        _listerFlowController.getIsLoading();
  }
}
