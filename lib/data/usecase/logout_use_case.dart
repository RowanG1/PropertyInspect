import '../../domain/repository/logout.dart';

class LogoutUseCase {
  Logout logoutRepo;

  LogoutUseCase(this.logoutRepo);

  execute() {
    logoutRepo.logout();
  }
}
