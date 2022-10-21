import 'package:get/get.dart';
import 'package:property_inspect/domain/usecase/analytics_use_case.dart';
import 'package:property_inspect/domain/usecase/login_state_use_case.dart';
import 'package:property_inspect/domain/usecase/logout_use_case.dart';
import 'package:property_inspect/domain/constants.dart';

class LoginController extends GetxController {
  final LoginStateUseCase _loginStateUseCase;
  final LogoutUseCase _logoutUseCase;
  final AnalyticsUseCase _analyticsUseCase;

  String? loginCompletionGoToRoute;
  final RxBool _loginState = false.obs;

  LoginController(
      this._loginStateUseCase, this._logoutUseCase, this._analyticsUseCase) {
    _loginState.bindStream(_loginStateUseCase.execute().skip(1));
  }

  @override
  void onInit() {
    getLoginState().stream.listen((val) {
      if (!val) {
        Get.toNamed(Constants.signInRoute);
      }
    });
  }

  RxBool getLoginState() {
    return _loginState;
  }

  logout() {
    return _logoutUseCase.execute();
  }

  logAnalyticsLoggedIn() {
    _analyticsUseCase.execute(Constants.loggedInAnalytics, {});
  }
}
