import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/controllers/create_listing_controller.dart';
import 'package:property_inspect/ui/pages/create_listing_form.dart';
import '../../application/usecase/analytics_use_case.dart';
import '../controllers/lister_flow_controller.dart';
import '../controllers/lister_registration_controller.dart';
import '../controllers/login_controller.dart';
import 'lister_flow.dart';

class CreateListingPage extends StatefulWidget {
  final CreateListingController createListingController;
  final AnalyticsUseCase analyticsUseCase;
  final LoginController loginController;
  final ListerRegistrationController listerRegistrationController;
  final ListerFlowController listerFlowController;

  CreateListingPage({Key? key, required this.createListingController, required this.analyticsUseCase, required this.loginController,
  required this.listerRegistrationController, required this.listerFlowController}) :
        super(key: key) {
    Get.put<CreateListingController>(createListingController);
    Get.put(listerFlowController);
    Get.put(listerRegistrationController);
  }

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  late final Worker getCreateListingStateSubscription;

  @override
  void initState() {
    super.initState();

    getCreateListingStateSubscription = ever(widget.createListingController.getCreateState(), (value) {
      if (value.content == true) {
        Get.back();
      }
      if (value.error != null && widget.loginController.getLoginState().value == true) {
        Get.snackbar("Error", value.error.toString(), backgroundColor: Colors.red);
        widget.analyticsUseCase.execute("create_listing_error", { 'error' : value
            .error});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListerFlow(pageTitle: "Create listing",
      listerFlowController: widget.listerFlowController,
      listerRegistrationController: widget.listerRegistrationController,
      analyticsUseCase: widget.analyticsUseCase,
      // This is where you give you custom widget it's data.
      body: Center(
        child: Obx(() => widget.createListingController.getIsLoading()
            ? const CircularProgressIndicator(
                value: null,
                semanticsLabel: 'Circular progress indicator',
              )
            : const CreateListingForm()),
      ),
    );
  }

  @override
  void dispose() {
    getCreateListingStateSubscription.dispose();
    super.dispose();
  }
}
