import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/controllers_builders.dart';
import 'package:property_inspect/ui/controllers/check_in_controller.dart';
import 'package:property_inspect/ui/pages/resume_after_authenticated_page.dart';
import 'package:property_inspect/ui/pages/visitor_registration_form.dart';
import '../controllers/visitor_registration_controller.dart';

class CheckinPage extends StatelessWidget {
  final CheckinController checkinController =
      Get.put(CheckinControllerBuilder().make());
  final VisitorRegistrationController registrationController = Get.put
      (VisitorRegistrationControllerBuilder().make());

  CheckinPage({Key? key}) : super(key: key) {
    String? id = Get.parameters['id'];
    checkinController.setPropertyId(id);
  }

  @override
  Widget build(BuildContext context) {
    final propertyId = checkinController.getPropertyId();
    return ResumeAfterAuthenticatedPage(
        body: Obx(() => Center(
            child: checkinController.getIsLoading() ? Text('Loading content')
                : checkinController.isRegistered() ?
            checkinController
            .isValidConfig()
                ? ValidCheckinContent()
                : Text('Invalid config for id: $propertyId') : VisitorRegistrationForm())));
  }
}

class ValidCheckinContent extends StatelessWidget {
  final CheckinController checkinController = Get.find<CheckinController>();

  ValidCheckinContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final propertyId = checkinController.getPropertyId();
    return Obx(() => checkinController.getIsLoading() ? Text('Loading '
        'content') : checkinController
        .getIsCheckedIn()
        ? Text('You have already checked in.')
        : ElevatedButton(
      onPressed: () {
        // Validate returns true if the form is valid, or false otherwise.
       checkinController.doCheckin();
      },
      child: Text('Click to check in to property: $propertyId'),
    ));
  }
}
