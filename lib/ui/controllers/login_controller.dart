import 'package:get/get.dart';
import 'package:property_inspect/data/usecase/login_use_case.dart';

class LoginController extends GetxController {
  LoginUseCase useCase;

  LoginController(this.useCase);

  RxBool getLoginState() {
    return useCase.loginState;
  }
}
