import 'package:firebase_auth/firebase_auth.dart' hide PhoneAuthProvider;
import 'package:property_inspect/data/types/optional.dart';
import 'package:property_inspect/domain/repository/login_repo.dart';
import 'package:rxdart/rxdart.dart';

class LoginFirebaseRepo implements LoginRepo {
  final BehaviorSubject<bool?> _isLoggedIn = BehaviorSubject.seeded(null);
  final BehaviorSubject<Optional<String>> _userId = BehaviorSubject.seeded
    (Optional<String>(null));

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
    _isLoggedIn.add(value);
  }

  @override
  Stream<bool?> getLoginState() {
    return _isLoggedIn.stream;
  }

  @override
  setUserId(String? userId) {
    _userId.add(Optional<String>(userId));
  }

  @override
  Stream<Optional<String>> getUserId() {
    return _userId.stream;
  }
}
