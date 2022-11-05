import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/use_case_factories.dart';
import 'package:property_inspect/domain/repository/analytics_repo.dart';
import 'package:property_inspect/domain/utils/field_validation.dart';
import 'package:property_inspect/ui/controllers/create_listing_controller.dart';
import '../../domain/constants.dart';
import '../../domain/usecase/analytics_use_case.dart';

class CreateListingForm extends StatefulWidget {
  const CreateListingForm({Key? key}) : super(key: key);

  @override
  CreateListingFormState createState() {
    return CreateListingFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CreateListingFormState extends State<CreateListingForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final CreateListingController controller = Get.find();
  final FieldValidation validation = FieldValidation();
  final AnalyticsUseCase _analyticsUseCase = AnalyticsUseCaseFactory().make();

  @override
  void initState() {
    super.initState();

    ever(controller.getCreateState(), (value) {
      if (value.content == true) {
        Get.back();
      }
      if (value.error != null) {
        Get.snackbar("Error", value.error.toString(), backgroundColor: Colors.red);
        _analyticsUseCase.execute("create_listing_error", { 'error' : value
            .error});
      }
    });
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
                child: Text(Constants.createListingHeading,
                    style: TextStyle(fontSize: Constants.headingSize)),
              ),
              TextFormField(
                controller: controller.addressController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: Constants.addressLabel,
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  return controller.validate(controller.addressController);
                },
              ),
              TextFormField(
                controller: controller.suburbController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: Constants.suburbListingLabel,
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  return controller.validate(controller.suburbController);
                },
              ),
              TextFormField(
                controller: controller.postCodeController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: Constants.postCodeLabel,
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  return controller.validate(controller.postCodeController);
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: Constants.largePadding),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      controller.createListing();
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
