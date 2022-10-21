import 'package:property_inspect/domain/entities/optional.dart';

abstract class LoginRepo {
  setLoginState(bool value);
  Stream<bool> getLoginState();
  setUserId(String? userId);
  Stream<Optional<String>> getUserId();
}
