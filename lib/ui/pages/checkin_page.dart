import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/controllers_factories.dart';
import 'package:property_inspect/ui/controllers/check_in_controller.dart';
import 'package:property_inspect/ui/pages/visitor_flow.dart';
import '../../domain/constants.dart';
import '../../domain/entities/listing.dart';
import '../../domain/entities/visitor.dart';
import '../controllers/login_controller.dart';

class CheckinPage extends StatefulWidget {
  CheckinPage({Key? key}) : super(key: key);

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  final CheckinController checkinController =
      Get.put(CheckinControllerFactory().make());

  late final Worker getCheckinStateSubscription;
  late final Worker getPropertyAvailableSubscription;
  final loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCheckinStateSubscription = ever(checkinController.getCheckinState(),
      (value) {
        if (value.error != null && loginController.getLoginState().value ==
        true) {
          Get.snackbar("Check-in state Error", value.error.toString(),
              backgroundColor: Colors.red);
        }
      });

      getPropertyAvailableSubscription = ever(checkinController
          .getListing(), (value) {
        if (value.error != null && loginController.getLoginState().value ==
            true) {
          Get.snackbar("Get Property Error", value.error.toString(),
              backgroundColor: Colors.red);
        }
      });
    });

    String? id = Get.parameters['id'];
    checkinController.setPropertyId(id);
  }

  @override
  Widget build(BuildContext context) {
    return VisitorFlow(pageTitle: "Check in",
        body: Obx(() => Center(
            child: checkinController.getIsLoading()
                ? CircularProgressIndicator(
                    value: null,
                    semanticsLabel: 'Circular progress indicator',
                  )
                : checkinController.isValidConfig()
                    ? ValidCheckinContent()
                    : Text('Sorry, we encountered a problem.'))));
  }

  @override
  void dispose() {
    getCheckinStateSubscription.dispose();
    getPropertyAvailableSubscription.dispose();
    super.dispose();
  }
}

class ValidCheckinContent extends StatelessWidget {
  final CheckinController checkinController = Get.find<CheckinController>();

  ValidCheckinContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Center(
          child: CheckinContent(
            property: checkinController.getListingValue()!,
            checkedIn: checkinController.getIsCheckedIn(),
            visitor: checkinController.getVisitor()!,
          ),
        ));
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
    final suburb = property.suburb;
    final postCode = property.postCode;
    final name = visitor.name;

    return Column(children: [
      Padding(
          padding: EdgeInsets.all(Constants.largePadding),
          child: Text('Welcome $name',
              style: TextStyle(fontSize: Constants.headingSize))),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0), child: Text('$address')),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0), child: Text('$suburb')),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0), child: Text('$postCode')),
      if (!checkedIn)
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              checkinController.doCheckin();
            },
            child: Text('Check in'),
          ),
        )
      else ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 55.0, 0, 0),
          child: Text('You have successfully checked in',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: const Icon(Icons.check_circle_outline_sharp, color: Colors.green, size: 60),
        )
      ]
    ]);
  }
}
