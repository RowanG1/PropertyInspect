import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/controllers_factories.dart';
import 'package:property_inspect/ui/pages/create_listing_form.dart';
import '../../data/di/use_case_factories.dart';
import '../../domain/usecase/analytics_use_case.dart';
import '../controllers/lister_flow_controller.dart';
import '../controllers/login_controller.dart';
import 'lister_flow.dart';

class CreateListingPage extends StatefulWidget {
  CreateListingPage({Key? key}) : super(key: key);

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  final LoginController _loginController = Get.find();
  final controller = Get.put(CreateListingControllerFactory().make());
  late final Worker getCreateListingStateSubscription;
  final AnalyticsUseCase _analyticsUseCase =
  AnalyticsUseCaseFactory().make();

  @override
  void initState() {
    super.initState();

    getCreateListingStateSubscription = ever(controller.getCreateState(), (value) {
      print("Got value from create listing");
      print('Content: ${value.content}, Loading ${value.loading}');
      if (value.content == true) {
        print('Going back after created listing');
        Get.back();
      }
      if (value.error != null && _loginController.getLoginState().value == true) {
        Get.snackbar("Error", value.error.toString(), backgroundColor: Colors.red);
        _analyticsUseCase.execute("create_listing_error", { 'error' : value
            .error});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListerFlow(pageTitle: "Create listing",
      // This is where you give you custom widget it's data.
      body: Center(
        child: Obx(() => controller.getIsLoading()
            ? CircularProgressIndicator(
                value: null,
                semanticsLabel: 'Circular progress indicator',
              )
            : CreateListingForm()),
      ),
    );
  }

  @override
  void dispose() {
    getCreateListingStateSubscription.dispose();
    super.dispose();
  }
}
