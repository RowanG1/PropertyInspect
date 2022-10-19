import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/domain/repository/listing_repo.dart';
import 'package:property_inspect/domain/repository/visitor_registration.dart';
import 'package:mockito/annotations.dart';
import 'package:property_inspect/domain/usecase/create_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/create_visitor_registration.dart';
import 'package:property_inspect/ui/controllers/create_listing_controller.dart';
import 'package:property_inspect/ui/controllers/visitor_registration_controller.dart';

import 'create_listing_test.mocks.dart';
import 'visitor_registration_test.mocks.dart';

@GenerateMocks([ListingRepo])
void main() {
  group('Visitor registration controller', () {
    ListingRepo createListingRepo;
    CreateListingUseCase createListingUseCase;
    late CreateListingController controller;

    setUp((){
      createListingRepo = MockCreateListing();
      createListingUseCase = CreateListingUseCase(createListingRepo);

      controller =
      CreateListingController(createListingUseCase);
    });

    test('validate address', () {
      Get.put(controller);
      controller.addressController.text = "32 Py Ave.";
      expect(controller.validate(controller.addressController), null);
      controller.addressController.text = "";
      expect(controller.validate(controller.addressController), Constants.defaultValidationLabel);
    });
  });
}
