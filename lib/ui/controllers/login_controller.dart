import 'package:get/get.dart';
import 'package:property_inspect/data/usecase/analytics_usecase.dart';
import 'package:property_inspect/data/usecase/login_state_use_case.dart';
import 'package:property_inspect/data/usecase/logout_use_case.dart';
import 'package:property_inspect/domain/constants.dart';

class LoginController extends GetxController {
  final LoginStateUseCase _loginStateUseCase;
  final LogoutUseCase _logoutUseCase;
  final AnalyticsUseCase _analyticsUseCase;

  LoginController(
      this._loginStateUseCase, this._logoutUseCase, this._analyticsUseCase);

  RxBool getLoginState() {
    return _loginStateUseCase.execute();
  }

  logout() {
    return _logoutUseCase.execute();
  }

  logAnalyticsLoggedIn() {
    _analyticsUseCase.execute(Constants.loggedInAnalytics, {});
  }
}
