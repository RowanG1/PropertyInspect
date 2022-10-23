import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/repository/listing_repo_firebase.dart';
import 'package:property_inspect/domain/usecase/create_listing_use_case.dart';
import 'package:property_inspect/ui/controllers/create_listing_controller.dart';
import 'package:property_inspect/ui/pages/create_listing_form.dart';
import 'lister_flow.dart';

class CreateListingPage extends StatelessWidget {
  CreateListingPage({Key? key}) : super(key: key);

  final controller = Get.put(CreateListingController(
      CreateListingUseCase(ListingRepoFirebase())));

  @override
  Widget build(BuildContext context) {
    return ListerFlow(
      // This is where you give you custom widget it's data.
      body: Center(child: CreateListingForm()),
    );
  }
}
