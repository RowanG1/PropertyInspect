import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/controllers_factories.dart';
import 'package:property_inspect/ui/pages/create_listing_form.dart';
import '../controllers/lister_flow_controller.dart';
import 'lister_flow.dart';

class CreateListingPage extends StatefulWidget {
  CreateListingPage({Key? key}) : super(key: key);

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  final controller = Get.put(CreateListingControllerFactory().make());
  final ListerFlowController listerFlowController = Get.find();

  @override
  Widget build(BuildContext context) {
    return FocusDetector(onFocusGained: () {
      listerFlowController.currentPage.value = "Create listing";
    },
      child: ListerFlow(pageTitle: "Create listing",
        // This is where you give you custom widget it's data.
        body: Center(
          child: Obx(() => controller.getIsLoading()
              ? CircularProgressIndicator(
                  value: null,
                  semanticsLabel: 'Circular progress indicator',
                )
              : CreateListingForm()),
        ),
      ),
    );
  }
}
