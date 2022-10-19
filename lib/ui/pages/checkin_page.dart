import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/controllers_builders.dart';
import 'package:property_inspect/ui/controllers/checkin_controller.dart';
import 'package:property_inspect/ui/pages/resume_after_authenticated_page.dart';
import '../controllers/login_controller.dart';

class CheckinPage extends StatelessWidget {
  final CheckinController checkinController =
      Get.put(CheckinControllerBuilder().make());

  CheckinPage({Key? key}) : super(key: key) {
    String? id = Get.parameters['id'];
    checkinController.setPropertyId(id);
  }

  @override
  Widget build(BuildContext context) {
    return ResumeAfterAuthenticatedPage(
        body: Obx(() => Center(
            child: checkinController.getIsLoading() ? Text('Loading content') :
            checkinController
            .isValidConfig()
                ? ValidCheckinContent()
                : Text('Invalid config'))));
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
        : Text('Please check in to property: $propertyId'
        '.'));
  }
}
