import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';

void main() {
  group('Login controller', () {
    test('set login state', () {
      var controller = LoginController();
      Get.put(controller);
      expect(controller.isLoggedIn.value, false);
      controller.setLoginState(true);
      expect(controller.isLoggedIn.value, true);
    });
  });
}
