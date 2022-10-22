import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/controllers_factories.dart';
import 'package:property_inspect/ui/pages/unauthenticated_page.dart';
import 'package:property_inspect/ui/pages/visitor_registration_form.dart';

class VisitorRegistrationPage extends StatelessWidget {
  VisitorRegistrationPage({Key? key}) : super(key: key);

  final controller = Get.put(VisitorRegistrationControllerFactory().make());

  @override
  Widget build(BuildContext context) {
    return const UnauthenticatedPage(
      // This is where you give you custom widget it's data.
      body: Center(child: VisitorRegistrationForm()),
    );
  }
}
