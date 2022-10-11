import 'package:get/get.dart';

abstract class Login {
  setLoginState(bool value);
  RxBool getLoginState();
}
