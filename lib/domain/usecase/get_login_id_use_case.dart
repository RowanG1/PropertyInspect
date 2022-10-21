import 'package:property_inspect/domain/entities/optional.dart';

import '../repository/login_repo.dart';

class GetLoginIdUseCase {
  LoginRepo loginRepo;

  GetLoginIdUseCase(this.loginRepo);

  Stream<Optional<String>> execute() {
    return  loginRepo.getUserId();
  }
}