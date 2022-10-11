import 'package:get/get.dart';
import 'package:property_inspect/data/repository/login_firebase.dart';
import '../../domain/repository/login.dart';

class LoginUseCase {
  Login loginRepo;
  late RxBool loginState;
  
  LoginUseCase(this.loginRepo) {
    loginState = loginRepo.getLoginState();
  }
}
