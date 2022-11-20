import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:property_inspect/domain/usecase/analytics_use_case.dart';
import 'package:property_inspect/domain/usecase/login_state_use_case.dart';
import 'package:property_inspect/domain/usecase/logout_use_case.dart';
import 'package:property_inspect/ui/controllers/package_controller.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/pages/privacy_policy_page.dart';
import '../login_controller_test.mocks.dart';
import '../login_repo_mock.dart';
import 'mock_package_controller.dart';
import 'overflow_helpers.dart';

@GenerateMocks([PackageController])
void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows building and interacting
  // with widgets in the test environment.
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Show privacy policy page.', (tester) async {
    FlutterError.onError = ignoreOverflowErrors;

    // Create the widget by telling the tester to build it.
    final loginRepo = LoginRepoTest();
    final loginUseCase = LoginStateUseCase(loginRepo);
    final logout = MockLogoutRepo();
    final logoutUseCase = LogoutUseCase(logout);
    final analyticsRepo = MockAnalyticsRepo();
    final packageController = MyMockPackageControllerFactory().make();
    final analyticsUseCase = AnalyticsUseCase(analyticsRepo);

    var controller = LoginController(loginUseCase, logoutUseCase, analyticsUseCase);

    Get.put(controller);
    Get.put<PackageController>(packageController);

    await tester.pumpWidget(const GetMaterialApp(home: PrivacyPolicyPage()));
    final policyFinder = find.textContaining('secure');
    expect(policyFinder, findsOneWidget);
  });
}
