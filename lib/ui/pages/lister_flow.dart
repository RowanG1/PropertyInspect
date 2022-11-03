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
import '../widgets/drawer.dart';

class ListerFlow extends StatefulWidget {
  final Widget body;
  final String? pageTitle;

  const ListerFlow({required this.body, this.pageTitle, Key? key})
      : super(key: key);

  @override
  State<ListerFlow> createState() => _ListerFlowState();
}

class _ListerFlowState extends State<ListerFlow> {
  final LoginController _loginController = Get.find();
  final ListerFlowController _listerFlowController = Get.find();
  final ListerRegistrationController _listerRegistrationController =
      Get.put(ListerRegistrationControllerFactory().make());
  late final Worker listerRegisterdSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      listerRegisterdSubscription =
          ever(_listerFlowController.getIsListerRegisteredRx(), (value) {
        if (value.error != null && _loginController.getLoginState().value ==
            true) {
          Get.snackbar("Lister registered error", value.error.toString(),
              backgroundColor: Colors.red);
        }
      });

      ever(_listerRegistrationController.getCreateListerState(), (value) {
        if (value.error != null) {
          Get.snackbar("Create Lister state Error", value.error.toString(),
              backgroundColor: Colors.red);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        endDrawer: SideDrawer(),
        appBar: AppBar(
          title: Text(widget.pageTitle ?? ""),
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

  @override
  void dispose() {
    listerRegisterdSubscription.dispose();
    super.dispose();
  }
}
