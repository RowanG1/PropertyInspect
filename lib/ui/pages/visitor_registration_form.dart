import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/controllers/visitor_registration_controller.dart';
import '../../domain/constants.dart';
import '../widgets/checkbox_form_field.dart';

class VisitorRegistrationForm extends StatefulWidget {
  const VisitorRegistrationForm({Key? key}) : super(key: key);

  @override
  VisitorRegistrationFormState createState() {
    return VisitorRegistrationFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class VisitorRegistrationFormState extends State<VisitorRegistrationForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final VisitorRegistrationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(Constants.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: Constants.largePadding),
                child: Text(Constants.visitorRegistrationHeading,
                    style: TextStyle(fontSize: Constants.headingSize)),
              ),
              TextFormField(key: ValueKey("name"),
                controller: controller.nameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: Constants.nameLabel,
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  return controller.validate(controller.nameController);
                },
              ),
              TextFormField(key: ValueKey("lastName"),
                controller: controller.lastNameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: Constants.lastNameLabel,
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  return controller.validate(controller.lastNameController);
                },
              ),
              TextFormField(key: ValueKey("phone"),
                controller: controller.phoneController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: Constants.phoneLabel,
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  return controller.validate(controller.phoneController);
                },
              ),
              TextFormField(key: ValueKey("email"),
                controller: controller.emailController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: Constants.emailLabel,
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  return controller.validate(controller.emailController);
                },
              ),
              TextFormField(key: ValueKey("suburb"),
                controller: controller.suburbController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: Constants.suburbLabel,
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  return controller.validate(controller.suburbController);
                },
              ),     Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  children: [
                    Text('Accept'),
                    TextButton(
                      child: Text('privacy policy'),
                      onPressed: () {
                        Get.toNamed(Constants.privacyPolicyRouteKey);
                      },
                    ),
                    CheckboxFormField(key: ValueKey('checkbox'), validator: controller.getCheckboxValidator()),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Constants.largePadding),
                child: ElevatedButton(key: ValueKey("submit"),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      print('Trying to create user');
                      controller.createUser();
                    }
                  },
                  child: const Text(Constants.submitLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
