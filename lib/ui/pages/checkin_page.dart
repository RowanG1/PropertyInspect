import 'dart:js_util';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/controllers_builders.dart';
import 'package:property_inspect/ui/controllers/check_in_controller.dart';
import 'package:property_inspect/ui/pages/resume_after_authenticated_page.dart';
import 'package:property_inspect/ui/pages/visitor_registration_form.dart';
import '../../domain/entities/listing.dart';
import '../controllers/visitor_registration_controller.dart';

class CheckinPage extends StatelessWidget {
  final CheckinController checkinController =
      Get.put(CheckinControllerBuilder().make());
  final VisitorRegistrationController registrationController =
      Get.put(VisitorRegistrationControllerBuilder().make());

  CheckinPage({Key? key}) : super(key: key) {
    String? id = Get.parameters['id'];
    checkinController.setPropertyId(id);
  }

  @override
  Widget build(BuildContext context) {
    final propertyId = checkinController.getPropertyId();
    return ResumeAfterAuthenticatedPage(
        body: Obx(() => Center(
            child: checkinController.getIsLoading()
                ? Text('Loading content')
                : checkinController.isRegistered()
                    ? checkinController.isValidConfig()
                        ? ValidCheckinContent()
                        : Text('Invalid config for id: $propertyId')
                    : VisitorRegistrationForm())));
  }
}

class ValidCheckinContent extends StatelessWidget {
  final CheckinController checkinController = Get.find<CheckinController>();

  ValidCheckinContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final property = checkinController.getListing().value.content;
    return Obx(() => checkinController.getIsLoading()
        ? const Text('Loading '
            'content')
        : checkinController.getIsCheckedIn()
            ? const Text('You have already checked in.')
            : CheckinContent(property: property));
  }
}

class CheckinContent extends StatelessWidget {
  final Listing? property;
  final CheckinController checkinController = Get.find<CheckinController>();

  CheckinContent({Key? key, this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final address = property?.address;

      if (property != null) {
        return Column(children: [
          Text('Welcome to property: $address'),
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
             checkinController.doCheckin();
            },
            child: Text('Check in.'),
          )
        ]);
      } else {
        return Text('Sorry, a problem occurred.');
      }
  }
}
