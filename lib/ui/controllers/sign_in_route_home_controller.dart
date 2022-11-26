import 'package:get/get.dart';
import '../../application/usecase/login_state_use_case.dart';

class SigninRouteHomeController extends GetxController {
  final LoginStateUseCase _loginStateUseCase;

  SigninRouteHomeController(this._loginStateUseCase);

  final Rx<bool?> _isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _isLoggedIn.bindStream(_loginStateUseCase.execute());
  }

  Rx<bool?> getIsLoggedIn() {
    return _isLoggedIn;
  }
}
