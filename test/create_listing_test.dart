import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/domain/repository/listing_repo.dart';
import 'package:property_inspect/domain/repository/login_repo.dart';
import 'package:mockito/annotations.dart';
import 'package:property_inspect/domain/usecase/create_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import 'package:property_inspect/ui/controllers/create_listing_controller.dart';
import 'create_listing_test.mocks.dart';
import 'login_repo_mock.dart';

@GenerateMocks([ListingRepo])
void main() {
  group('Visitor registration controller', () {
    ListingRepo createListingRepo;
    LoginRepo loginRepo;
    CreateListingUseCase createListingUseCase;
    GetLoginIdUseCase loginIdUseCase;
    late CreateListingController controller;

    setUp((){
      loginRepo = LoginRepoTest();
      createListingRepo = MockListingRepo();
      createListingUseCase = CreateListingUseCase(createListingRepo);
      loginIdUseCase = GetLoginIdUseCase(loginRepo);
      controller =
      CreateListingController(createListingUseCase, loginIdUseCase);
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
