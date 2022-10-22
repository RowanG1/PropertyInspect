import 'package:get/get.dart';
import '../../domain/constants.dart';
import '../../domain/usecase/login_state_use_case.dart';

class SigninRouteHomeController extends GetxController {
  final LoginStateUseCase _loginStateUseCase;

  SigninRouteHomeController(this._loginStateUseCase);

  final RxBool _isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();

    _isLoggedIn.bindStream(_loginStateUseCase.execute());

    ever(_isLoggedIn, (value) {
      print("login state has changed in sign home route controller.");
      if (value == true) {
       // Get.offAllNamed(Constants.homeRoute);
      }
    });
  }
}
