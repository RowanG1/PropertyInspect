import 'package:get/get.dart';
import '../../domain/repository/login_state.dart';

class LoginStateUseCase {
  LoginState loginRepo;
  late RxBool _loginState;

  LoginStateUseCase(this.loginRepo) {
    _loginState = loginRepo.getLoginState();
  }

  execute() {
    return _loginState;
  }
}
