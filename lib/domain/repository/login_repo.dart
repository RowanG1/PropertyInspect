import 'package:property_inspect/data/types/optional.dart';

abstract class LoginRepo {
  setLoginState(bool value);
  Stream<bool> getLoginState();
  setUserId(String? userId);
  Stream<Optional<String>> getUserId();
}
