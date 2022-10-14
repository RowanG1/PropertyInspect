import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/repository/visitor_registration_firebase.dart';
import 'package:property_inspect/domain/usecase/create_visitor_registration.dart';
import 'package:property_inspect/ui/controllers/user_registration_controller.dart';
import 'package:property_inspect/ui/pages/visitor_registration_form.dart';
import '../../domain/utils/field_validation.dart';
import 'authenticated_page.dart';

class VisitorRegistrationPage extends StatelessWidget {
  VisitorRegistrationPage({Key? key}) : super(key: key);

  final controller = Get.put(VisitorRegistrationController(
      CreateVisitorRegistrationUseCase(VisitorRegistrationFirebase())));

  @override
  Widget build(BuildContext context) {
    return const AuthenticatedPage(
      // This is where you give you custom widget it's data.
      body: Center(child: VisitorRegistrationForm()),
    );
  }
}
