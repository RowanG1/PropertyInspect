import 'package:property_inspect/data/types/optional.dart';
import 'package:property_inspect/domain/repository/login_repo.dart';
import 'package:rxdart/rxdart.dart';

class LoginRepoTest implements LoginRepo {
  BehaviorSubject<bool> _isLoggedIn = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<Optional<String>> _loginId = BehaviorSubject<Optional<String>>.seeded(Optional("345"));

  @override
  Stream<bool> getLoginState() {
    return _isLoggedIn.stream;
  }

  @override
  setLoginState(bool value) {
    _isLoggedIn.add(value);
  }

  @override
  Stream<Optional<String>> getUserId() {
    return _loginId.stream;
  }

  @override
  setUserId(String? userId) {
    _loginId.value = Optional(userId);
  }
}
