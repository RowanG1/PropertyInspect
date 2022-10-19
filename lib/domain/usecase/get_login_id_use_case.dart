import '../repository/login_state.dart';

class GetLoginIdUseCase {
  LoginState loginRepo;

  GetLoginIdUseCase(this.loginRepo);

  execute() {
    return  loginRepo.getUserId();
  }
}