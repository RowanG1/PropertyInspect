import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/controllers_factories.dart';
import 'package:property_inspect/ui/controllers/check_in_controller.dart';
import 'package:property_inspect/ui/pages/visitor_flow.dart';
import '../../domain/constants.dart';
import '../../domain/entities/listing.dart';
import '../../domain/entities/visitor.dart';
import '../controllers/visitor_registration_controller.dart';

class CheckinPage extends StatefulWidget {
  CheckinPage({Key? key}) : super(key: key);

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  final CheckinController checkinController =
      Get.put(CheckinControllerFactory().make());

  final VisitorRegistrationController registrationController =
      Get.put(VisitorRegistrationControllerFactory().make());

  @override
  void initState() {
    super.initState();
    String? id = Get.parameters['id'];
    checkinController.setPropertyId(id);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ever(checkinController.getCheckinState(), (value) {
        if (value.error != null) {
          Get.snackbar("Error", value.error.toString(),
              backgroundColor: Colors.red);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisitorFlow(
        body: Obx(() => Center(
            child: checkinController.getIsLoading()
                ? Text('Loading content')
                : checkinController.isValidConfig()
                    ? ValidCheckinContent()
                    : Text('Sorry, we encountered a problem.'))));
  }
}

class ValidCheckinContent extends StatelessWidget {
  final CheckinController checkinController = Get.find<CheckinController>();

  ValidCheckinContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VisitorFlow(
        // This is where you give you custom widget it's data.
        body: Obx(() => Center(
              child: checkinController.getIsLoading()
                  ? const Text('Loading '
                      'content')
                  : CheckinContent(
                      property: checkinController.getListingValue()!,
                      checkedIn: checkinController.getIsCheckedIn(),
                      visitor: checkinController.getVisitor()!,
                    ),
            )));
  }
}

class CheckinContent extends StatelessWidget {
  final Listing property;
  final bool checkedIn;
  final Visitor visitor;
  final CheckinController checkinController = Get.find<CheckinController>();

  CheckinContent(
      {Key? key,
      required this.property,
      required this.checkedIn,
      required this.visitor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final address = property.address;
    final name = visitor.name;

    return Column(children: [
      Padding(
          padding: EdgeInsets.all(Constants.largePadding),
          child: Text('Welcome $name',
              style: TextStyle(fontSize: Constants.headingSize))),
      Padding(
          padding: EdgeInsets.all(Constants.largePadding),
          child: Text('🏠 Address: $address')),
      !checkedIn
          ? ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                checkinController.doCheckin();
              },
              child: Text('Check in'),
            )
          : Text('You have successfully checked in ✅',
              style: TextStyle(fontWeight: FontWeight.bold))
    ]);
  }
}
