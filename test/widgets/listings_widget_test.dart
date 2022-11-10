import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/domain/entities/lister.dart';
import 'package:property_inspect/domain/entities/listing.dart';
import 'package:property_inspect/domain/repository/analytics_repo.dart';
import 'package:property_inspect/domain/repository/lister_registration_repo.dart';
import 'package:property_inspect/domain/repository/listing_repo.dart';
import 'package:property_inspect/domain/repository/login_repo.dart';
import 'package:mockito/annotations.dart';
import 'package:property_inspect/domain/repository/logout_repo.dart';
import 'package:property_inspect/domain/usecase/analytics_use_case.dart';
import 'package:property_inspect/domain/usecase/create_lister_registration.dart';
import 'package:property_inspect/domain/usecase/create_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/delete_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/do_checkins_exist_use_case.dart';
import 'package:property_inspect/domain/usecase/get_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/get_listings_use_case.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import 'package:property_inspect/domain/usecase/is_lister_registered_use_case.dart';
import 'package:property_inspect/domain/usecase/login_state_use_case.dart';
import 'package:property_inspect/domain/usecase/logout_use_case.dart';
import 'package:property_inspect/ui/controllers/PackageController.dart';
import 'package:property_inspect/ui/controllers/lister_flow_controller.dart';
import 'package:property_inspect/ui/controllers/lister_registration_controller.dart';
import 'package:property_inspect/ui/controllers/listings_controller.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/controllers/test_mode_controller.dart';
import 'package:property_inspect/ui/controllers/view_listing_controller.dart';
import 'package:property_inspect/ui/pages/listing_page.dart';
import 'package:property_inspect/ui/pages/listings_page.dart';
import 'package:property_inspect/ui/pages/unauthenticated_page.dart';
import '../login_registration_mock.dart';
import '../login_repo_mock.dart';
import 'checkin_repo_mock.dart';
import 'listing_widget_test.mocks.dart';
import 'mock_package_controller.dart';

@GenerateMocks([ListingRepo, AnalyticsRepo, LogoutRepo])
void main() {
  group('Listings table', () {
    late LoginRepo loginRepo;
    LogoutRepo logoutRepo;
    late MockAnalyticsRepo analyticsRepo;
    late AnalyticsUseCase analyticsUseCase;
    GetLoginIdUseCase loginIdUseCase;
    late LoginStateUseCase loginStateUseCase;
    late LogoutUseCase logoutUseCase;
    late LoginController loginController;
    late ListerFlowController listerFlowController;
    late ListerRegistrationController listerRegistrationController;
    late ListerRegistrationRepoTest listerRegistrationRepo;
    late IsListerRegisteredUseCase isListerRegisteredUseCase;
    late CreateListerRegistrationUseCase createListerRegistrationUseCase;
    late GetListingsUseCase getListingsUseCase;
    late ListingRepo listingRepo;
    late DoCheckinsExistForListingUseCase doCheckinsExistForListingUseCase;
    late DeleteListingUseCase deleteListingUseCase;
    late ListingsController listingsController;
    late CheckinRepoMock checkinRepo;
    late PackageController packageController;

    setUp(() {
      loginRepo = LoginRepoTest();
      analyticsRepo = MockAnalyticsRepo();
      analyticsUseCase = AnalyticsUseCase(analyticsRepo);
      loginIdUseCase = GetLoginIdUseCase(loginRepo);
      loginStateUseCase = LoginStateUseCase(loginRepo);
      logoutRepo = MockLogoutRepo();
      logoutUseCase = LogoutUseCase(logoutRepo);
      loginController = LoginController(loginStateUseCase, logoutUseCase, analyticsUseCase);
      listerRegistrationRepo = ListerRegistrationRepoTest();
      isListerRegisteredUseCase = IsListerRegisteredUseCase(listerRegistrationRepo);
      listerFlowController = ListerFlowController(isListerRegisteredUseCase, loginIdUseCase);
      createListerRegistrationUseCase = CreateListerRegistrationUseCase(listerRegistrationRepo);
      listerRegistrationController = ListerRegistrationController(createListerRegistrationUseCase, loginIdUseCase, analyticsUseCase);
      listingRepo = MockListingRepo();
      getListingsUseCase = GetListingsUseCase(listingRepo);
      checkinRepo = CheckinRepoMock();
      doCheckinsExistForListingUseCase = DoCheckinsExistForListingUseCase(checkinRepo);
      deleteListingUseCase = DeleteListingUseCase(listingRepo);
      listingsController = ListingsController(getListingsUseCase, loginIdUseCase, deleteListingUseCase);
      packageController = MyMockPackageController();

      when(listingRepo.getListings('345')).thenAnswer(
          (_) => Stream.value([Listing(id: '123', userId: '345', address: '32 Bell', suburb: 'Pyrmont', postCode: '2345', phone: '23456'),
            Listing(id: '124', userId: '345', address: '32 Bell', suburb: 'Richmond', postCode: '234', phone: '234567')
          ]));
    });

    testWidgets('Show listings page.', (tester) async {
      Get.put(loginController);
      Get.put(packageController);
      Get.put(TestModeController(isTestMode: true));

      await tester.pumpWidget(GetMaterialApp(initialRoute: Constants.homeRoute, getPages: [
        GetPage(
            name: Constants.homeRoute,
            page: () => UnauthenticatedPage(
                  body: Text('Home page for test'),
                )),
        GetPage(
            name: Constants.listingsRoute,
            page: () => ListingsPage(
                controller: listingsController,
                analyticsUseCase: analyticsUseCase,
                listerFlowController: listerFlowController,
                listerRegistrationController: listerRegistrationController)),
        GetPage(
            name: Constants.listingRoute,
            page: () => UnauthenticatedPage(
              body: Text('Listing page for test'),
            ))
      ]));

      Get.toNamed(Constants.listingsRoute);

      await tester.pumpAndSettle();

      // Expect sign in page.
      final signInPageFinder = find.textContaining('Sign in');
      expect(signInPageFinder, findsOneWidget);

      loginRepo.setLoginState(true);
      await tester.pumpAndSettle();

      // Now expect registration page.
      final registrationFinder = find.textContaining('registration');
      expect(registrationFinder, findsOneWidget);

      listerRegistrationRepo.setIsRegistered(true);
      await tester.pumpAndSettle();

      // Now view listings
      final suburbPageFinder = find.textContaining('Pyrmont');
      expect(suburbPageFinder, findsOneWidget);

      final suburb2PageFinder = find.textContaining('Richmond');
      expect(suburb2PageFinder, findsOneWidget);

      final viewBtn1Find = find.byKey(ValueKey("view_btn_1"));
      await tester.tap(viewBtn1Find);

      expect(Get.currentRoute, equals('${Constants.listingBaseRoute}/124'));
    });
  });
}
