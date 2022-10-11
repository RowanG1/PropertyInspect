import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/usecase/login_state_use_case.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';

import 'login_repo.dart';

void main() {
  group('Login controller', () {
    test('set login state', () {
      final loginRepo = LoginRepoTest();
      final loginUseCase = LoginStateUseCase(loginRepo);

      var controller = LoginController(loginUseCase);
      Get.put(controller);
      expect(controller.getLoginState().value, false);

      loginRepo.setLoginState(true);
      expect(controller.getLoginState().value, true);
    });
  });
}
