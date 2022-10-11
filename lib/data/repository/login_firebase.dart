import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/repository/login.dart';

class LoginFirebase implements Login {
  RxBool isLoggedIn = false.obs;

  LoginFirebase() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        setLoginState(false);
      } else {
        setLoginState(true);
      }
    });
  }

  @override
  setLoginState(bool value) {
    isLoggedIn.value = value;
  }

  @override
  RxBool getLoginState() {
    return isLoggedIn;
  }
}
