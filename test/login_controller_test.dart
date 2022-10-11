import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/usecase/analytics_usecase.dart';
import 'package:property_inspect/data/usecase/login_state_use_case.dart';
import 'package:property_inspect/data/usecase/logout_use_case.dart';
import 'package:property_inspect/domain/repository/analytics.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/domain/repository/logout.dart';
import 'login_repo_mock.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_controller_test.mocks.dart';

@GenerateMocks([Logout, Analytics])
void main() {
  group('Login controller', () {
    test('set login state', () {
      final loginRepo = LoginRepoTest();
      final loginUseCase = LoginStateUseCase(loginRepo);
      final logout = MockLogout();
      final logoutUseCase = LogoutUseCase(logout);
      final analyticsRepo = MockAnalytics();
      final analyticsUseCase = AnalyticsUseCase(analyticsRepo);

      var controller =
          LoginController(loginUseCase, logoutUseCase, analyticsUseCase);

      Get.put(controller);
      expect(controller.getLoginState().value, false);

      loginRepo.setLoginState(true);
      expect(controller.getLoginState().value, true);
    });
  });
}
