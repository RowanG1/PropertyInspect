import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoggedIn = false.obs;
  setLoginState(bool value) => isLoggedIn.value = value;
}
