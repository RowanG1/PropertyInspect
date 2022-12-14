import 'package:get/get.dart';
import 'package:property_inspect/application/usecase/analytics_use_case.dart';
import 'package:property_inspect/application/usecase/login_state_use_case.dart';
import 'package:property_inspect/application/usecase/logout_use_case.dart';
import 'package:property_inspect/domain/constants.dart';

class LoginController extends GetxController {
  final LoginStateUseCase _loginStateUseCase;
  final LogoutUseCase _logoutUseCase;
  final AnalyticsUseCase _analyticsUseCase;

  String? loginCompletionGoToRoute;
  // ignore: unnecessary_cast
  final Rx<bool?> _loginState = (null as bool?).obs;

  LoginController(
      this._loginStateUseCase, this._logoutUseCase, this._analyticsUseCase)
       {
    _loginState.bindStream(_loginStateUseCase.execute());
  }

  Rx<bool?> getLoginState() {
    return _loginState;
  }

  logout() {
    return _logoutUseCase.execute();
  }

  logAnalyticsLoggedIn() {
    _analyticsUseCase.execute(Constants.loggedInAnalytics, {});
  }
}
