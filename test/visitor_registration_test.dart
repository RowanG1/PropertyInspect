import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/use_case_factories.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/domain/repository/analytics_repo.dart';
import 'package:property_inspect/domain/repository/login_repo.dart';
import 'package:property_inspect/domain/repository/visitor_registration_repo.dart';
import 'package:mockito/annotations.dart';
import 'package:property_inspect/domain/usecase/analytics_use_case.dart';
import 'package:property_inspect/domain/usecase/create_visitor_registration_use_case.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import 'package:property_inspect/ui/controllers/visitor_registration_controller.dart';
import 'login_controller_test.mocks.dart';
import 'login_repo_mock.dart';
import 'visitor_registration_test.mocks.dart';

@GenerateMocks([VisitorRegistrationRepo, AnalyticsRepo])
void main() {
  group('Visitor registration controller', () {
    VisitorRegistrationRepo visitorRepo;
    LoginRepo loginRepo;
    CreateVisitorRegistrationUseCase visitorRegisterUseCase;
    AnalyticsRepo analyticsRepo;
    AnalyticsUseCase analyticsUseCase;
    GetLoginIdUseCase loginIdUseCase;
    late VisitorRegistrationController controller;

    setUp(() {
      visitorRepo = MockVisitorRegistrationRepo();
      visitorRegisterUseCase = CreateVisitorRegistrationUseCase(visitorRepo);
      loginRepo = LoginRepoTest();
      loginIdUseCase = GetLoginIdUseCase(loginRepo);
      analyticsRepo = MockAnalyticsRepo();
      analyticsUseCase = AnalyticsUseCase(analyticsRepo);
      controller = VisitorRegistrationController(
          visitorRegisterUseCase, loginIdUseCase, analyticsUseCase);
    });

    test('validate email', () {
      Get.put(controller);
      controller.emailController.text = "rgon";
      expect(controller.validate(controller.emailController),
          Constants.emailValidationLabel);
      controller.emailController.text = "rgon@gm.com";
      expect(controller.validate(controller.emailController), null);
    });

    test('validate suburb', () {
      Get.put(controller);
      controller.suburbController.text = "pyrmo";
      expect(controller.validate(controller.suburbController), null);
      controller.suburbController.text = "";
      expect(controller.validate(controller.suburbController),
          Constants.defaultValidationLabel);
    });
  });
}
