import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:property_inspect/application/usecase/analytics_use_case.dart';
import 'package:property_inspect/application/usecase/login_state_use_case.dart';
import 'package:property_inspect/application/usecase/logout_use_case.dart';
import 'package:property_inspect/domain/repository/analytics_repo.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/domain/repository/logout_repo.dart';
import 'login_repo_mock.dart';
import 'package:mockito/annotations.dart';
import 'login_controller_test.mocks.dart';

@GenerateMocks([LogoutRepo, AnalyticsRepo])
void main() {
  group('Login controller', () {
    test('set login state', () {
      final loginRepo = LoginRepoTest();
      final loginUseCase = LoginStateUseCase(loginRepo);
      final logout = MockLogoutRepo();
      final logoutUseCase = LogoutUseCase(logout);
      final analyticsRepo = MockAnalyticsRepo();
      final analyticsUseCase = AnalyticsUseCase(analyticsRepo);

      var controller =
          LoginController(loginUseCase, logoutUseCase, analyticsUseCase);

      Get.put(controller);
      expect(controller.getLoginState().value, null);
      loginRepo.setLoginState(true);
      expectLater(controller.getLoginState().stream, emitsInOrder([false,
        true]));
    });
  });
}
