import 'package:get/get.dart';
import 'package:property_inspect/data/repository/login_repo_firebase.dart';
import 'package:property_inspect/domain/repository/login_repo.dart';

class LoginRepoFactory {
  static final _repo = Get.put<LoginRepo>(LoginFirebaseRepo());

  static LoginRepo get() {
    return _repo;
  }
}
