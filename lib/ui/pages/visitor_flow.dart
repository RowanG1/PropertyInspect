import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/controllers_factories.dart';
import 'package:property_inspect/ui/controllers/visitor_registration_controller.dart';
import 'package:property_inspect/ui/pages/signin_container.dart';
import 'package:property_inspect/ui/pages/visitor_registration_form.dart';
import '../controllers/login_controller.dart';
import '../controllers/visitor_flow_controller.dart';
import '../widgets/drawer.dart';

class VisitorFlow extends StatefulWidget {
  final Widget body;
  final String? pageTitle;

  VisitorFlow({required this.body, this.pageTitle, Key? key}) : super(key: key);

  @override
  State<VisitorFlow> createState() => _VisitorFlowState();
}

class _VisitorFlowState extends State<VisitorFlow> {
  final LoginController _loginController = Get.find();

  final VisitorFlowController _visitorFlowController = Get.find();

  final VisitorRegistrationController _visitorRegistrationController =
      Get.put(VisitorRegistrationControllerFactory().make());

  late final Worker isVisitorRegisteredSubscription;
  late final Worker isVisitorRegisterationCreatedSubscription;
  final loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      isVisitorRegisteredSubscription =
          ever(_visitorFlowController.getIsVisitorRegisteredRx(), (value) {
        if (value.error != null && loginController.getLoginState().value ==
            true) {
          Get.snackbar("Visitor Is Registered Error", value.error.toString(),
              backgroundColor: Colors.red);
        }
      });

      isVisitorRegisterationCreatedSubscription =
          ever(_visitorRegistrationController.getCreateState(), (value) {
        if (value.error != null) {
          Get.snackbar("Is Visitor Created Error", value.error.toString(),
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
        appBar: AppBar(title: Text(widget.pageTitle ?? "")),
        body: Obx(
          () => isLoading()
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
    );
  }

  bool isLoading() {
    return _visitorRegistrationController.isLoading() ||
        _visitorFlowController.getIsLoading();
  }

  @override
  void dispose() {
    isVisitorRegisteredSubscription.dispose();
    isVisitorRegisterationCreatedSubscription.dispose();
    super.dispose();
  }
}
