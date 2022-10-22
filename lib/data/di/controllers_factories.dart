import 'package:property_inspect/data/di/use_case_factories.dart';
import 'package:property_inspect/ui/controllers/check_in_controller.dart';
import 'package:property_inspect/ui/controllers/sign_in_route_home_controller.dart';
import '../../ui/controllers/visitor_registration_controller.dart';

class CheckinControllerFactory {
  CheckinController make() {
    return CheckinController(CheckedInUseCaseFactory().make(),
        ListingAvailableUseCaseFactory().make(), GetLoginIdUseCaseFactory()
          .make(), DoCheckInUseCaseFactory().make(),
        IsVisitorRegisteredUseCaseFactory().make(), GetListingUseCaseFactory().make
          (), GetVisitorUseCaseFactory().make());
  }
}

class SigninRouteHomeControllerFactory {
  SigninRouteHomeController make() {
    return SigninRouteHomeController(LoginStateUseCaseFactory().make());
  }
}

class VisitorRegistrationControllerFactory {
  VisitorRegistrationController make() {
    return VisitorRegistrationController
      (CreateVisitorRegistrationUseCaseFactory().make(),
        GetLoginIdUseCaseFactory().make());
  }
}
