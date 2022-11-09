import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mockito/annotations.dart';
import 'package:property_inspect/domain/entities/visitor.dart';
import 'package:property_inspect/domain/repository/analytics_repo.dart';
import 'package:property_inspect/domain/repository/checkin_repo.dart';
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
import '../login_repo_mock.dart';
import 'checkin_widget_test.mocks.dart';
import 'mock_package_controller.dart';

@GenerateMocks([ AnalyticsRepo, VisitorRegistrationRepo, LogoutRepo, CheckinRepo, ListingRepo])
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
    late CheckinRepo checkinRepo;
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
      visitorRegistrationRepo = MockVisitorRegistrationRepo();
      visitorRegisteredUseCase = GetIsVisitorRegisteredUseCase(visitorRegistrationRepo);
      loginController = LoginController(loginStateUseCase, logoutUseCase, analyticsUseCase);
      visitorFlowController = VisitorFlowController(visitorRegisteredUseCase, loginIdUseCase);
      createVisitorRegistrationUseCase = CreateVisitorRegistrationUseCase(visitorRegistrationRepo);
      visitorRegistrationController = VisitorRegistrationController(createVisitorRegistrationUseCase, loginIdUseCase, analyticsUseCase);
      checkinRepo = MockCheckinRepo();
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
    });

    testWidgets('checkin', (tester) async {
      await tester.pumpWidget(GetMaterialApp(
          home: CheckinPage(
            analyticsUseCase: analyticsUseCase,
            loginController: loginController,
            visitorFlowController: visitorFlowController,
            visitorRegistrationController: visitorRegistrationController,
            checkinController: checkinController,
          )));
    });
  });
}
