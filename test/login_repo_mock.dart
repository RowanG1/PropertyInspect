import 'package:property_inspect/domain/entities/optional.dart';
import 'package:property_inspect/domain/repository/login_repo.dart';
import 'package:rxdart/rxdart.dart';

class LoginRepoTest implements LoginRepo {
  BehaviorSubject<bool> _isLoggedIn = BehaviorSubject<bool>.seeded(false);

  @override
  Stream<bool> getLoginState() {
    return _isLoggedIn;
  }

  @override
  setLoginState(bool value) {
    _isLoggedIn.value = value;
  }

  @override
  Stream<Optional<String>> getUserId() {
    // TODO: implement getUserId
    throw UnimplementedError();
  }

  @override
  setUserId(String? userId) {
    // TODO: implement setUserId
    throw UnimplementedError();
  }
}
