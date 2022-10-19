import 'package:firebase_auth/firebase_auth.dart' hide PhoneAuthProvider;
import 'package:get/get.dart';
import 'package:property_inspect/domain/repository/login_state.dart';

class LoginFirebaseRepo implements LoginState {
  RxBool isLoggedIn = false.obs;
  String? userId;

  LoginFirebaseRepo() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        setLoginState(false);
        setUserId(user?.uid);
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

  @override
  setUserId(String? userId) {
    this.userId = userId;
  }

  @override
  String? getUserId() {
    return userId;
  }
}
