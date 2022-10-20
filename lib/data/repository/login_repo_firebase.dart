import 'package:firebase_auth/firebase_auth.dart' hide PhoneAuthProvider;
import 'package:get/get.dart';
import 'package:property_inspect/domain/repository/login_repo.dart';

class LoginFirebaseRepo implements LoginRepo {
  final RxBool _isLoggedIn = false.obs;
  String? userId;

  LoginFirebaseRepo() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      setUserId(user?.uid);
      if (user == null) {
        setLoginState(false);
      } else {
        setLoginState(true);
      }
    });
  }

  @override
  setLoginState(bool value) {
    _isLoggedIn.value = value;
  }

  @override
  RxBool getLoginState() {
    return _isLoggedIn;
  }

  @override
  setUserId(String? userId) {
    print('Setting user id in fire repo $userId');
    this.userId = userId;
  }

  @override
  String? getUserId() {
    return userId;
  }
}
