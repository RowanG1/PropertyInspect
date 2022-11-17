import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/controllers/check_in_controller.dart';
import 'package:property_inspect/ui/pages/visitor_flow.dart';
import '../../domain/constants.dart';
import '../../domain/entities/listing.dart';
import '../../domain/entities/visitor.dart';
import '../../domain/usecase/analytics_use_case.dart';
import '../controllers/login_controller.dart';
import '../controllers/visitor_flow_controller.dart';
import '../controllers/visitor_registration_controller.dart';

class CheckinPage extends StatefulWidget {
  final AnalyticsUseCase analyticsUseCase;
  final LoginController loginController;
  final VisitorFlowController visitorFlowController;
  final VisitorRegistrationController visitorRegistrationController;
  final CheckinController checkinController;

  CheckinPage(
      {Key? key,
      required this.analyticsUseCase,
      required this.loginController,
      required this.visitorFlowController,
      required this.visitorRegistrationController,
      required this.checkinController})
      : super(key: key) {
    Get.put(visitorRegistrationController);
    Get.put(visitorFlowController);
    Get.put(checkinController);
  }

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  late final Worker getCheckinStateSubscription;
  late final Worker getPropertyAvailableSubscription;
  final loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCheckinStateSubscription = ever(widget.checkinController.getCheckinState(), (value) {
        if (value.error != null && loginController.getLoginState().value == true) {
          Get.snackbar("Check-in state Error", value.error.toString(), backgroundColor: Colors.red);
          widget.analyticsUseCase.execute("checked_in_state_error", {'error': value.error});
        }
      });

      getPropertyAvailableSubscription = ever(widget.checkinController.getListing(), (value) {
        if (value.error != null && loginController.getLoginState().value == true) {
          Get.snackbar("Get Property Error", value.error.toString(), backgroundColor: Colors.red);
          widget.analyticsUseCase.execute("get_property_error", {'error': value.error, 'page': 'checkin'});
        }
      });
    });

    String? id = Get.parameters['id'];
    widget.checkinController.setPropertyId(id);
  }

  @override
  Widget build(BuildContext context) {
    return VisitorFlow(
        analyticsUseCase: widget.analyticsUseCase,
        loginController: widget.loginController,
        visitorFlowController: widget.visitorFlowController,
        visitorRegistrationController: widget.visitorRegistrationController,
        pageTitle: "Check in",
        body: Obx(() => Center(key: ValueKey('Center'),
            child: widget.checkinController.getIsLoading()
                ? CircularProgressIndicator(
                    value: null,
                    semanticsLabel: 'Circular progress indicator',
                  )
                : widget.checkinController.isValidConfig()
                    ? ValidCheckinContent()
                    : Text('Sorry, we encountered a problem.'))));
  }

  @override
  void dispose() {
    getCheckinStateSubscription.dispose();
    getPropertyAvailableSubscription.dispose();
    widget.checkinController.dispose();
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

  CheckinContent({Key? key, required this.property, required this.checkedIn, required this.visitor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final address = property.address;
    final suburb = property.suburb;
    final postCode = property.postCode;
    final name = visitor.name;

    return Column(children: [
      Padding(
          padding: EdgeInsets.all(Constants.largePadding), child: Text('Welcome $name', style: TextStyle(fontSize: Constants.headingSize))),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 100,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text("Address:", textAlign: TextAlign.end,),
              ),
            ),
            SizedBox(width: 100,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  address,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Suburb:", textAlign: TextAlign.end,),
            ),
          ),
          SizedBox(width: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(suburb, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Post code:", textAlign: TextAlign.end),
            ),
          ),
          SizedBox(width: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(postCode, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      if (!checkedIn)
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 40.0, 0, 0),
          child: ElevatedButton(key: ValueKey("checkin"),
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              checkinController.doCheckin();
            },
            child: Text('Check in'),
          ),
        )
      else ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Text('You have successfully checked in', style: TextStyle(fontWeight: FontWeight.bold), key: ValueKey('Success')),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: const Icon(Icons.check_circle_outline_sharp, color: Colors.green, size: 60),
        )
      ]
    ]);
  }
}
