import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/domain/entities/listing.dart';
import 'package:property_inspect/domain/repository/analytics_repo.dart';
import 'package:property_inspect/domain/repository/listing_repo.dart';
import 'package:property_inspect/domain/repository/login_repo.dart';
import 'package:property_inspect/domain/repository/logout_repo.dart';
import 'package:property_inspect/domain/repository/visitor_registration_repo.dart';
import 'package:property_inspect/domain/usecase/analytics_use_case.dart';
import 'package:property_inspect/domain/usecase/checked_in_use_case.dart';
import 'package:property_inspect/domain/usecase/create_visitor_registration_use_case.dart';
import 'package:property_inspect/domain/usecase/do_checkin_use_case.dart';
import 'package:property_inspect/domain/usecase/get_is_visitor_registerd_use_case.dart';
import 'package:property_inspect/domain/usecase/get_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import 'package:property_inspect/domain/usecase/get_visitor_use_case.dart';
import 'package:property_inspect/domain/usecase/login_state_use_case.dart';
import 'package:property_inspect/domain/usecase/logout_use_case.dart';
import 'package:property_inspect/ui/controllers/PackageController.dart';
import 'package:property_inspect/ui/controllers/check_in_controller.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/controllers/test_mode_controller.dart';
import 'package:property_inspect/ui/controllers/visitor_flow_controller.dart';
import 'package:property_inspect/ui/controllers/visitor_registration_controller.dart';
import 'package:property_inspect/ui/pages/checkin_page.dart';
import 'package:property_inspect/ui/pages/unauthenticated_page.dart';
import '../login_repo_mock.dart';
import 'checkin_repo_mock.dart';
import 'checkin_widget_test.mocks.dart';
import 'mock_package_controller.dart';
import 'visitor_registration_repo_mock.dart';

@GenerateMocks([ AnalyticsRepo, LogoutRepo, ListingRepo])
void main() {
  group('Checkin widget', () {
    late MockAnalyticsRepo analyticsRepo;
    late AnalyticsUseCase analyticsUseCase;
    late LoginRepo loginRepo;
    late LoginController loginController;
    LogoutRepo logoutRepo;
    late LoginStateUseCase loginStateUseCase;
    late LogoutUseCase logoutUseCase;
    GetLoginIdUseCase loginIdUseCase;
    VisitorRegistrationRepo visitorRegistrationRepo;
    late GetIsVisitorRegisteredUseCase visitorRegisteredUseCase;
    late CreateVisitorRegistrationUseCase createVisitorRegistrationUseCase;
    late VisitorFlowController visitorFlowController;
    late VisitorRegistrationController visitorRegistrationController;
    late CheckinRepoMock checkinRepo;
    late CheckedInUseCase checkedInUseCase;
    late DoCheckinUseCase doCheckinUseCase;
    late ListingRepo listingRepo;
    late GetListingUseCase getListingUseCase;
    late GetVisitorUseCase getVisitorUseCase;
    late CheckinController checkinController;
    late PackageController packageController;

    setUp(() {
      analyticsRepo = MockAnalyticsRepo();
      analyticsUseCase = AnalyticsUseCase(analyticsRepo);
      loginRepo = LoginRepoTest();
      loginStateUseCase = LoginStateUseCase(loginRepo);
      loginIdUseCase = GetLoginIdUseCase(loginRepo);
      logoutRepo = MockLogoutRepo();
      logoutUseCase = LogoutUseCase(logoutRepo);
      visitorRegistrationRepo = VisitorRegistrationRepoMock();
      visitorRegisteredUseCase = GetIsVisitorRegisteredUseCase(visitorRegistrationRepo);
      loginController = LoginController(loginStateUseCase, logoutUseCase, analyticsUseCase);
      visitorFlowController = VisitorFlowController(visitorRegisteredUseCase, loginIdUseCase);
      createVisitorRegistrationUseCase = CreateVisitorRegistrationUseCase(visitorRegistrationRepo);
      visitorRegistrationController = VisitorRegistrationController(createVisitorRegistrationUseCase, loginIdUseCase, analyticsUseCase);
      checkinRepo = CheckinRepoMock();
      checkedInUseCase = CheckedInUseCase(checkinRepo);
      doCheckinUseCase = DoCheckinUseCase(checkinRepo);
      listingRepo = MockListingRepo();
      getListingUseCase = GetListingUseCase(listingRepo);
      getVisitorUseCase = GetVisitorUseCase(visitorRegistrationRepo);
      checkinController = CheckinController(checkedInUseCase, loginIdUseCase, doCheckinUseCase, getListingUseCase, getVisitorUseCase, analyticsUseCase);
      packageController = MyMockPackageController();

      Get.put(loginController);
      Get.put(packageController);
      Get.put(TestModeController(isTestMode: true));

      when(listingRepo.getListing('123')).
      thenAnswer((_) => Stream.value(Listing(id: '123',userId: '23', address: '32 Bell', suburb: 'Pyrmont', postCode:
      '2345', phone: '23456')));
    });

    testWidgets('show checkin page.', (tester) async {
      await tester.pumpWidget(GetMaterialApp(initialRoute: Constants.homeRoute,
          getPages: [
          GetPage(name: Constants.homeRoute, page: () => UnauthenticatedPage(
            body: Text('Home page for test'),
          )),
          GetPage(name: Constants.checkinRoute, page: () => CheckinPage(
            analyticsUseCase: analyticsUseCase,
            loginController: loginController,
            visitorFlowController: visitorFlowController,
            visitorRegistrationController: visitorRegistrationController,
            checkinController: checkinController,
          ))]));

      await tester.pumpAndSettle();

      Get.toNamed(Constants.checkinBaseRoute+'/123');

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

      final suburbFind = find.byKey(ValueKey("suburb"));
      await tester.enterText(suburbFind, "Pyrmont");

      final submitFind = find.byKey(ValueKey("submit"));
      await tester.tap(submitFind);

      await tester.pumpAndSettle();

      // Now checkin

      final checkinFind = find.byKey(ValueKey("Checkin"));
      expect(checkinFind, findsOneWidget);

      await tester.tap(checkinFind);
      await tester.pumpAndSettle();

      final successFind = find.byKey(ValueKey("Success"));
      expect(successFind, findsOneWidget);

    });
  });
}
