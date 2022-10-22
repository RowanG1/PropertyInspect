import 'package:property_inspect/data/di/use_case_builders.dart';
import 'package:property_inspect/ui/controllers/check_in_controller.dart';
import 'package:property_inspect/ui/controllers/sign_in_route_home_controller.dart';
import '../../ui/controllers/visitor_registration_controller.dart';

class CheckinControllerBuilder {
  CheckinController make() {
    return CheckinController(CheckedInUseCaseBuilder().make(),
        ListingAvailableUseCaseBuilder().make(), GetLoginIdUseCaseBuilder()
          .make(), DoCheckInUseCaseBuilder().make(),
        IsVisitorRegisteredUseCaseBuilder().make(), GetListingUseCaseBuilder().make
          ());
  }
}

class SigninRouteHomeControllerBuilder {
  SigninRouteHomeController make() {
    return SigninRouteHomeController(LoginStateUseCaseBuilder().make());
  }
}

class VisitorRegistrationControllerBuilder {
  VisitorRegistrationController make() {
    return VisitorRegistrationController
      (CreateVisitorRegistrationUseCaseBuilder().make(),
        GetLoginIdUseCaseBuilder().make());
  }
}
