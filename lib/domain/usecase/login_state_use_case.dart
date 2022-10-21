import '../../domain/repository/login_repo.dart';

class LoginStateUseCase {
  LoginRepo loginRepo;
  late Stream<bool> _loginState;

  LoginStateUseCase(this.loginRepo) {
    _loginState = loginRepo.getLoginState();
  }

  Stream<bool> execute() {
    return _loginState;
  }
}
