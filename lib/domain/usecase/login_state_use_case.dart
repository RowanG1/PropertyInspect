import 'package:get/get.dart';
import '../../domain/repository/login_repo.dart';

class LoginStateUseCase {
  LoginRepo loginRepo;
  late RxBool _loginState;

  LoginStateUseCase(this.loginRepo) {
    _loginState = loginRepo.getLoginState();
  }

  execute() {
    return _loginState;
  }
}
