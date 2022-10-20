import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/repository/visitor_registration_firebase.dart';
import 'package:property_inspect/domain/usecase/create_visitor_registration_use_case.dart';
import 'package:property_inspect/ui/controllers/visitor_registration_controller.dart';
import 'package:property_inspect/ui/pages/unauthenticated_page.dart';
import 'package:property_inspect/ui/pages/visitor_registration_form.dart';

class VisitorRegistrationPage extends StatelessWidget {
  VisitorRegistrationPage({Key? key}) : super(key: key);

  final controller = Get.put(VisitorRegistrationController(
      CreateVisitorRegistrationUseCase(VisitorRegistrationFirebaseRepo())));

  @override
  Widget build(BuildContext context) {
    return const UnauthenticatedPage(
      // This is where you give you custom widget it's data.
      body: Center(child: VisitorRegistrationForm()),
    );
  }
}
