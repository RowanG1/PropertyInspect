import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:property_inspect/data/types/env.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/domain/repository/analytics_repo.dart';
import 'package:property_inspect/domain/repository/listing_repo.dart';
import 'package:property_inspect/domain/repository/login_repo.dart';
import 'package:mockito/annotations.dart';
import 'package:property_inspect/domain/repository/logout_repo.dart';
import 'package:property_inspect/application/usecase/analytics_use_case.dart';
import 'package:property_inspect/application/usecase/create_lister_registration.dart';
import 'package:property_inspect/application/usecase/create_listing_use_case.dart';
import 'package:property_inspect/application/usecase/get_login_id_use_case.dart';
import 'package:property_inspect/application/usecase/is_lister_registered_use_case.dart';
import 'package:property_inspect/application/usecase/login_state_use_case.dart';
import 'package:property_inspect/application/usecase/logout_use_case.dart';
import 'package:property_inspect/ui/controllers/package_controller.dart';
import 'package:property_inspect/ui/controllers/create_listing_controller.dart';
import 'package:property_inspect/ui/controllers/lister_flow_controller.dart';
import 'package:property_inspect/ui/controllers/lister_registration_controller.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/pages/create_listing_page.dart';
import 'package:property_inspect/ui/pages/unauthenticated_page.dart';
import '../login_registration_mock.dart';
import './create_listing_widget_test.mocks.dart';
import '../login_repo_mock.dart';
import 'mock_package_controller.dart';

@GenerateMocks([ListingRepo, AnalyticsRepo, LogoutRepo])
void main() {
  group('Create listing', () {
    ListingRepo createListingRepo;
    late LoginRepo loginRepo;
    LogoutRepo logoutRepo;
    CreateListingUseCase createListingUseCase;
    late MockAnalyticsRepo analyticsRepo;
    late AnalyticsUseCase analyticsUseCase;
    GetLoginIdUseCase loginIdUseCase;
    late CreateListingController controller;
    late LoginStateUseCase loginStateUseCase;
    late LogoutUseCase logoutUseCase;
    late LoginController loginController;
    late ListerFlowController listerFlowController;
    late ListerRegistrationController listerRegistrationController;
    late ListerRegistrationRepoTest listerRegistrationRepo;
    late IsListerRegisteredUseCase isListerRegisteredUseCase;
    late CreateListerRegistrationUseCase createListerRegistrationUseCase;
    late PackageController packageController;

    setUp(() {
      Get.put(Logger());
      loginRepo = LoginRepoTest();
      createListingRepo = MockListingRepo();
      createListingUseCase = CreateListingUseCase(createListingRepo);
      analyticsRepo = MockAnalyticsRepo();
      analyticsUseCase = AnalyticsUseCase(analyticsRepo);
      loginIdUseCase = GetLoginIdUseCase(loginRepo);
      controller = CreateListingController(createListingUseCase, loginIdUseCase, analyticsUseCase);
      loginStateUseCase = LoginStateUseCase(loginRepo);
      logoutRepo = MockLogoutRepo();
      logoutUseCase = LogoutUseCase(logoutRepo);
      loginController = LoginController(loginStateUseCase, logoutUseCase, analyticsUseCase);
      listerRegistrationRepo = ListerRegistrationRepoTest();
      isListerRegisteredUseCase = IsListerRegisteredUseCase(listerRegistrationRepo);
      listerFlowController = ListerFlowController(isListerRegisteredUseCase, loginIdUseCase);
      createListerRegistrationUseCase = CreateListerRegistrationUseCase(listerRegistrationRepo);
      listerRegistrationController = ListerRegistrationController(createListerRegistrationUseCase, loginIdUseCase, analyticsUseCase);
      packageController = MyMockPackageControllerFactory().make();
    });

    testWidgets('show create listing page.', (tester) async {
      Get.put(loginController);
      Get.put(packageController);
      Get.put(Env(appTitle: "Title", env: Constants.unitTestEnv));

      await tester.pumpWidget(const GetMaterialApp(
          home: UnauthenticatedPage(
        body: Text('Home page for test'),
      )));

      Get.to(CreateListingPage(
          createListingController: controller,
          analyticsUseCase: analyticsUseCase,
          loginController: loginController,
          listerFlowController: listerFlowController,
          listerRegistrationController: listerRegistrationController));

      await tester.pumpAndSettle();

      // Expect sign in page.
      final signInPageFinder = find.textContaining('Sign in');
      expect(signInPageFinder, findsOneWidget);

      loginRepo.setLoginState(true);
      await tester.pumpAndSettle();

      // Now expect registration page.
      final registrationFinder = find.textContaining('registration');
      expect(registrationFinder, findsOneWidget);

      await tester.pumpAndSettle();

      final nameFind = find.byKey(const ValueKey("name"));
      await tester.enterText(nameFind, "Rowan");

      final lastNameFind = find.byKey(const ValueKey("lastName"));
      await tester.enterText(lastNameFind, "Gont");

      final phoneFind = find.byKey(const ValueKey("phone"));
      await tester.enterText(phoneFind, "3435678");

      final emailFind = find.byKey(const ValueKey("email"));
      await tester.enterText(emailFind, "rgon@gmail.com");

      final checkboxFind = find.byKey(const ValueKey("checkbox"));
      await tester.tap(checkboxFind);

      final submitFind = find.byKey(const ValueKey("submit"));

      await tester.tap(submitFind);

      await tester.pumpAndSettle();

      // Now create listing

      final createListingFinder = find.textContaining('listing form');
      expect(createListingFinder, findsOneWidget);

      final addressFind = find.byKey(const ValueKey("address"));
      await tester.enterText(addressFind, "12 Willingdon St.");

      final suburbFind = find.byKey(const ValueKey("suburb"));
      await tester.enterText(suburbFind, "Pyrmont");

      final postCodeFind = find.byKey(const ValueKey("postCode"));
      await tester.enterText(postCodeFind, "2009");

      await tester.enterText(phoneFind, "3435678");

      await tester.tap(submitFind);

      await tester.pumpAndSettle();

      final homePageFinder = find.textContaining('Home page');
      expect(homePageFinder, findsOneWidget);
    });
  });
}
