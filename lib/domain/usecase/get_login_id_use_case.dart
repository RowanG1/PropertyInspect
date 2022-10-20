import '../repository/login_repo.dart';

class GetLoginIdUseCase {
  LoginRepo loginRepo;

  GetLoginIdUseCase(this.loginRepo);

  execute() {
    return  loginRepo.getUserId();
  }
}