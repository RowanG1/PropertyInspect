import 'package:property_inspect/data/types/optional.dart';
import 'package:property_inspect/domain/repository/login_repo.dart';
import 'package:rxdart/rxdart.dart';

class LoginRepoTest implements LoginRepo {
  BehaviorSubject<bool> _isLoggedIn = BehaviorSubject<bool>.seeded(false);

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
    return Stream.value(Optional("345"));
  }

  @override
  setUserId(String? userId) {

  }
}
