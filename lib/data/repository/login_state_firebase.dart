import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/repository/login_state.dart';

class LoginFirebaseRepo implements LoginState {
  RxBool isLoggedIn = false.obs;

  LoginFirebaseRepo() {
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
