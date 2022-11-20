import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/usecase/analytics_use_case.dart';
import 'package:property_inspect/ui/controllers/lister_registration_controller.dart';
import 'package:property_inspect/ui/pages/lister_registration_form.dart';
import 'package:property_inspect/ui/pages/signin_container.dart';
import '../controllers/lister_flow_controller.dart';
import '../controllers/login_controller.dart';
import '../widgets/drawer.dart';

class ListerFlow extends StatefulWidget {
  final Widget body;
  final String? pageTitle;
  final ListerRegistrationController listerRegistrationController;
  final ListerFlowController listerFlowController;
  final AnalyticsUseCase analyticsUseCase;

  const ListerFlow({required this.body, this.pageTitle, required this.listerRegistrationController, required this.listerFlowController,
    required this.analyticsUseCase, Key? key}) : super(key: key);

  @override
  State<ListerFlow> createState() => _ListerFlowState();
}

class _ListerFlowState extends State<ListerFlow> {
  final LoginController _loginController = Get.find();
  final ListerFlowController _listerFlowController = Get.find();
  late final Worker isListerRegisteredSubscription;
  late final Worker createListerSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      isListerRegisteredSubscription = ever(_listerFlowController.getIsListerRegisteredRx(), (value) {
        if (value.error != null && _loginController.getLoginState().value == true) {
          Get.snackbar("Lister registered error", value.error.toString(), backgroundColor: Colors.red);
          widget.analyticsUseCase.execute("is_lister_registered_error", {'error': value.error, 'page': 'lister_flow'});
        }
      });

      createListerSubscription = ever(widget.listerRegistrationController.getCreateListerState(), (value) {
        if (value.error != null && _loginController.getLoginState().value == true) {
          Get.snackbar("Create Lister state Error", value.error.toString(), backgroundColor: Colors.red);
          widget.analyticsUseCase.execute("create_lister_state_error", {
            'error': value.error, 'page': 'lister_flow'});
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
            ? const Center(
                child: CircularProgressIndicator(
                  value: null,
                  semanticsLabel: 'Circular progress indicator',
                ),
              )
            : _loginController.getLoginState().value == true
                ? (_listerFlowController.getIsListerRegistered() ? widget.body : const ListerRegistrationForm())
                : SignInContainer()),
      ),
    );
  }

  bool isLoading() {
    return widget.listerRegistrationController.isLoading() ||
        _listerFlowController.getIsLoading() ||
        _loginController.getLoginState().value == null;
  }

  @override
  void dispose() {
    isListerRegisteredSubscription.dispose();
    createListerSubscription.dispose();
    super.dispose();
  }
}
