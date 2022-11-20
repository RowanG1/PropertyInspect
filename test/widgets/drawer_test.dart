import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:property_inspect/domain/repository/analytics_repo.dart';
import 'package:property_inspect/domain/repository/logout_repo.dart';
import 'package:property_inspect/domain/repository/package_repo.dart';
import 'package:property_inspect/domain/usecase/analytics_use_case.dart';
import 'package:property_inspect/domain/usecase/login_state_use_case.dart';
import 'package:property_inspect/domain/usecase/logout_use_case.dart';
import 'package:property_inspect/ui/controllers/package_controller.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/widgets/drawer.dart';
import '../login_repo_mock.dart';
import 'mock_package_controller.dart';
import 'overflow_helpers.dart';
import 'drawer_test.mocks.dart';

@GenerateMocks([LogoutRepo, PackageInfoRepo, AnalyticsRepo])
void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows building and interacting
  // with widgets in the test environment.
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<PackageInfo> getPackageInfo() {
    final packageInfo = PackageInfo(appName: "Good", version: '23',
        buildNumber: '43',
        packageName:
        "MyPackage");
    return Future<PackageInfo>.value(packageInfo);
  }

  testWidgets('Checkin shows checkin button for new visitor.', (tester) async {
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

    await tester.pumpWidget(GetMaterialApp(home: SideDrawer()));

    final contactUsOptionFinder = find.textContaining('Contact us');
    expect(contactUsOptionFinder, findsOneWidget);

    final logoutOptionFinder = find.textContaining('Log out');
    expect(logoutOptionFinder, findsNothing);

    loginRepo.setLoginState(true);
    await tester.pump();

    expect(logoutOptionFinder, findsOneWidget);
  });
}


