import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:property_inspect/data/di/controllers_factories.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/domain/repository/analytics_repo.dart';
import 'package:property_inspect/domain/repository/lister_registration_repo.dart';
import 'package:property_inspect/domain/repository/listing_repo.dart';
import 'package:property_inspect/domain/repository/login_repo.dart';
import 'package:mockito/annotations.dart';
import 'package:property_inspect/domain/repository/logout_repo.dart';
import 'package:property_inspect/domain/usecase/analytics_use_case.dart';
import 'package:property_inspect/domain/usecase/create_lister_registration.dart';
import 'package:property_inspect/domain/usecase/create_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import 'package:property_inspect/domain/usecase/is_lister_registered_use_case.dart';
import 'package:property_inspect/domain/usecase/login_state_use_case.dart';
import 'package:property_inspect/domain/usecase/logout_use_case.dart';
import 'package:property_inspect/ui/controllers/PackageController.dart';
import 'package:property_inspect/ui/controllers/create_listing_controller.dart';
import 'package:property_inspect/ui/controllers/lister_flow_controller.dart';
import 'package:property_inspect/ui/controllers/lister_registration_controller.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/controllers/test_mode_controller.dart';
import 'package:property_inspect/ui/pages/create_listing_page.dart';
import 'package:property_inspect/ui/pages/unauthenticated_page.dart';
import '../login_registration_mock.dart';
import './create_listing_widget_test.mocks.dart';
import '../login_repo_mock.dart';
import 'mock_package_controller.dart';

@GenerateMocks([ListingRepo, AnalyticsRepo, LogoutRepo, ListerRegistrationRepo])
void main() {
  group('Visitor registration controller', () {
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
      packageController = MyMockPackageController();
    });

    testWidgets('create listing', (tester) async {
      Get.put(loginController);
      Get.put(packageController);
      Get.put(TestModeController(isTestMode: true));

      await tester.pumpWidget(GetMaterialApp(
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

      final nameFind = find.byKey(ValueKey("name"));
      await tester.enterText(nameFind, "Rowan");

      final lastNameFind = find.byKey(ValueKey("lastName"));
      await tester.enterText(lastNameFind, "Gont");

      final phoneFind = find.byKey(ValueKey("phone"));
      await tester.enterText(phoneFind, "3435678");

      final emailFind = find.byKey(ValueKey("email"));
      await tester.enterText(emailFind, "rgon@gmail.com");

      final submitFind = find.byKey(ValueKey("submit"));

      await tester.tap(submitFind);

      await tester.pumpAndSettle();

      // Now create listing

      final createListingFinder = find.textContaining('listing form');
      expect(createListingFinder, findsOneWidget);

      final addressFind = find.byKey(ValueKey("address"));
      await tester.enterText(addressFind, "12 Willingdon St.");

      final suburbFind = find.byKey(ValueKey("suburb"));
      await tester.enterText(suburbFind, "Pyrmont");

      final postCodeFind = find.byKey(ValueKey("postCode"));
      await tester.enterText(postCodeFind, "2009");

      await tester.enterText(phoneFind, "3435678");

      await tester.tap(submitFind);

      await tester.pumpAndSettle();

      final homePageFinder = find.textContaining('Home page');
      expect(homePageFinder, findsOneWidget);
    });
  });
}
