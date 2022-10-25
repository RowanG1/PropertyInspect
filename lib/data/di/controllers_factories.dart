import 'package:property_inspect/data/di/use_case_factories.dart';
import 'package:property_inspect/domain/usecase/create_lister_registration.dart';
import 'package:property_inspect/domain/usecase/get_checkins_for_listing_use_case.dart';
import 'package:property_inspect/ui/controllers/check_in_controller.dart';
import 'package:property_inspect/ui/controllers/checkins_controller.dart';
import 'package:property_inspect/ui/controllers/lister_registration_controller.dart';
import 'package:property_inspect/ui/controllers/listings_controller.dart';
import 'package:property_inspect/ui/controllers/sign_in_route_home_controller.dart';
import '../../ui/controllers/lister_flow_controller.dart';
import '../../ui/controllers/view_listing_controller.dart';
import '../../ui/controllers/visitor_flow_controller.dart';
import '../../ui/controllers/visitor_registration_controller.dart';

class CheckinControllerFactory {
  CheckinController make() {
    return CheckinController(
        CheckedInUseCaseFactory().make(),
        ListingAvailableUseCaseFactory().make(),
        GetLoginIdUseCaseFactory().make(),
        DoCheckInUseCaseFactory().make(),
        GetListingUseCaseFactory().make(),
        GetVisitorUseCaseFactory().make());
  }
}

class SigninRouteHomeControllerFactory {
  SigninRouteHomeController make() {
    return SigninRouteHomeController(LoginStateUseCaseFactory().make());
  }
}

class VisitorRegistrationControllerFactory {
  VisitorRegistrationController make() {
    return VisitorRegistrationController(
        CreateVisitorRegistrationUseCaseFactory().make(),
        GetLoginIdUseCaseFactory().make());
  }
}

class VisitorFlowControllerFactory {
  VisitorFlowController make() {
    return VisitorFlowController(
        IsVisitorRegisteredUseCaseFactory().make(),
        GetLoginIdUseCaseFactory().make());
  }
}

class ListerFlowControllerFactory {
  ListerFlowController make() {
    return ListerFlowController(
        IsListerRegisteredUseCaseFactory().make(),
        GetLoginIdUseCaseFactory().make());
  }
}

class ListerRegistrationControllerFactory {
  ListerRegistrationController make() {
    return ListerRegistrationController(
        CreateListerRegistrationUseCaseFactory().make(),
        GetLoginIdUseCaseFactory().make());
  }
}

class ViewListingControllerFactory {
  ViewListingController make() {
    return ViewListingController(
        GetListingUseCaseFactory().make());
  }
}

class ViewListingsControllerFactory {
  ListingsController make() {
    return ListingsController(
        GetListingsUseCaseFactory().make(), GetLoginIdUseCaseFactory().make()
      , DeleteListingUseCaseFactory().make());
  }
}

class GetCheckinsControllerFactory {
  CheckinsController make() {
    return CheckinsController(GetLoginIdUseCaseFactory().make(),
        GetCheckinsUseCaseFactory().make());
  }
}