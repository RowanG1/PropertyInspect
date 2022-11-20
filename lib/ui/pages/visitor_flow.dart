import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/controllers/visitor_registration_controller.dart';
import 'package:property_inspect/ui/pages/signin_container.dart';
import 'package:property_inspect/ui/pages/visitor_registration_form.dart';
import '../../domain/usecase/analytics_use_case.dart';
import '../controllers/login_controller.dart';
import '../controllers/visitor_flow_controller.dart';
import '../widgets/drawer.dart';

class VisitorFlow extends StatefulWidget {
  final Widget body;
  final String? pageTitle;
  final VisitorFlowController visitorFlowController;
  final VisitorRegistrationController visitorRegistrationController;
  final LoginController loginController;
  final AnalyticsUseCase analyticsUseCase;

  const VisitorFlow({required this.body, this.pageTitle, required this.visitorFlowController, required this.visitorRegistrationController, required this
      .loginController, required this.analyticsUseCase, Key? key}) :
        super(key: key);

  @override
  State<VisitorFlow> createState() => _VisitorFlowState();
}

class _VisitorFlowState extends State<VisitorFlow> {
  late final Worker isVisitorRegisteredSubscription;
  late final Worker isVisitorRegisterationCreatedSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      isVisitorRegisteredSubscription = ever(widget.visitorFlowController.getIsVisitorRegisteredRx(), (value) {
        if (value.error != null && widget.loginController.getLoginState().value == true) {
          Get.snackbar("Visitor Is Registered Error", value.error.toString(), backgroundColor: Colors.red);
          widget.analyticsUseCase.execute("is_visitor_registered_error", {'error': value.error});
        }
      });

      isVisitorRegisterationCreatedSubscription = ever(widget.visitorRegistrationController.getCreateState(), (value) {
        if (value.error != null && widget.loginController.getLoginState().value == true) {
          Get.snackbar("Is Visitor Created Error", value.error.toString(), backgroundColor: Colors.red);
          widget.analyticsUseCase.execute("create_visitor_error", {'error': value.error});
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
              ? const Center(
                  child: CircularProgressIndicator(
                    value: null,
                    semanticsLabel: 'Circular progress indicator',
                  ),
                )
              : widget.loginController.getLoginState().value == true
                  ? (widget.visitorFlowController.getIsVisitorRegistered() ? widget.body : const VisitorRegistrationForm())
                  : const SignInContainer(),
        ),
      ),
    );
  }

  bool isLoading() {
    return widget.visitorRegistrationController.isLoading() ||
        widget.visitorFlowController.getIsLoading() ||
        widget.loginController.getLoginState().value == null;
  }

  @override
  void dispose() {
    isVisitorRegisteredSubscription.dispose();
    isVisitorRegisterationCreatedSubscription.dispose();
    widget.visitorFlowController.dispose();
    widget.visitorRegistrationController.dispose();
    super.dispose();
  }
}
