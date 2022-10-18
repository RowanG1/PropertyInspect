import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/pages/resume_after_authenticated_page.dart';

class CheckinPage extends StatelessWidget {
  late String? propertyId;

  CheckinPage({Key? key}) : super(key: key) {
    String? id = Get.parameters['id'];
    print("Id is: $id");
    propertyId = id;
  }

  @override
  Widget build(BuildContext context) {
    return ResumeAfterAuthenticatedPage(
        // This is where you give you custom widget it's data.
        body: Center(child:
        TextButton(
          onPressed: () {
            print('Signing in to property: $propertyId');
          },
          child: Text('Checkin here to property with id: $propertyId'),
        )
       ));
  }
}
