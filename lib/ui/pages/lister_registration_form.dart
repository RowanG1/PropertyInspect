import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/constants.dart';
import '../controllers/lister_flow_controller.dart';
import '../controllers/lister_registration_controller.dart';

class ListerRegistrationForm extends StatefulWidget {
  const ListerRegistrationForm({Key? key}) : super(key: key);

  @override
  ListerRegistrationFormState createState() {
    return ListerRegistrationFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ListerRegistrationFormState extends State<ListerRegistrationForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final ListerRegistrationController controller = Get.find();
  final ListerFlowController listerFlowController = Get.find();

  @override
  void initState() {
    super.initState();
    listerFlowController.currentPage.value = "Lister registration";
  }

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
                child: Text(Constants.listerRegistrationHeading,
                    style: TextStyle(fontSize: Constants.headingSize)),
              ),
              TextFormField(
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
              TextFormField(
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
              TextFormField(
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
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: Constants.emailLabel,
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  controller.validate(controller.emailController);
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Constants.largePadding),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      controller.createRegistration();
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
