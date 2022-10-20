import 'package:get/get.dart';

abstract class LoginRepo {
  setLoginState(bool value);
  RxBool getLoginState();
  setUserId(String? userId);
  String? getUserId();
}
