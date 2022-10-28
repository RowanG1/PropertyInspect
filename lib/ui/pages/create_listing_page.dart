import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/use_case_factories.dart';
import 'package:property_inspect/ui/controllers/create_listing_controller.dart';
import 'package:property_inspect/ui/pages/create_listing_form.dart';
import 'lister_flow.dart';

class CreateListingPage extends StatelessWidget {
  CreateListingPage({Key? key}) : super(key: key);

  final controller = Get.put(CreateListingController(
      CreateListingUseCaseFactory().make(), GetLoginIdUseCaseFactory().make()));

  @override
  Widget build(BuildContext context) {
    return ListerFlow(
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
}
