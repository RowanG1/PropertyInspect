import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:property_inspect/domain/repository/login_state.dart';

class LoginRepoTest implements LoginState {
  RxBool isLoggedIn = false.obs;

  @override
  RxBool getLoginState() {
    return isLoggedIn;
  }

  @override
  setLoginState(bool value) {
    isLoggedIn.value = value;
  }

  @override
  String? getUserId() {
    // TODO: implement getUserId
    throw UnimplementedError();
  }

  @override
  setUserId(String? userId) {
    // TODO: implement setUserId
    throw UnimplementedError();
  }
}
