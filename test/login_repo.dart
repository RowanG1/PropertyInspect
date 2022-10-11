import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:property_inspect/domain/repository/login.dart';

class LoginRepoTest implements Login {
  RxBool isLoggedIn = false.obs;

  @override
  RxBool getLoginState() {
    return isLoggedIn;
  }

  @override
  setLoginState(bool value) {
    isLoggedIn.value = value;
  }
}
