import '../../domain/repository/logout_repo.dart';

class LogoutUseCase {
  LogoutRepo logoutRepo;

  LogoutUseCase(this.logoutRepo);

  execute() {
    logoutRepo.logout();
  }
}
