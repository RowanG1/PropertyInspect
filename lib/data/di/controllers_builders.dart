import 'package:property_inspect/data/di/use_case_builders.dart';
import 'package:property_inspect/ui/controllers/check_in_controller.dart';
import 'package:property_inspect/ui/controllers/sign_in_route_home_controller.dart';

class CheckinControllerBuilder {
  CheckinController make() {
    return CheckinController(CheckedInUseCaseBuilder().make(),
        ListingAvailableUseCaseBuilder().make(), GetLoginIdUseCaseBuilder()
          .make(), DoCheckInUseCaseBuilder().make());
  }
}

class SigninRouteHomeControllerBuilder {
  SigninRouteHomeController make() {
    return SigninRouteHomeController(LoginStateUseCaseBuilder().make());
  }
}
