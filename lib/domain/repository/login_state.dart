import 'package:get/get.dart';

abstract class LoginState {
  setLoginState(bool value);
  RxBool getLoginState();
  setUserId(String? userId);
  String? getUserId();
}
