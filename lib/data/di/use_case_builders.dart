import 'package:property_inspect/data/repository/checkin_firebase_repo.dart';
import 'package:property_inspect/data/repository/listing_repo_firebase.dart';
import 'package:property_inspect/data/repository/login_repo_firebase.dart';
import 'package:property_inspect/data/repository/visitor_registration_firebase.dart';
import 'package:property_inspect/domain/repository/visitor_registration_repo.dart';
import 'package:property_inspect/domain/usecase/checked_in_use_case.dart';
import 'package:property_inspect/domain/usecase/do_checkin_use_case.dart';
import 'package:property_inspect/domain/usecase/get_is_visitor_registerd_use_case.dart';
import 'package:property_inspect/domain/usecase/get_listing_available_use_case.dart';
import 'package:property_inspect/domain/usecase/get_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import 'package:property_inspect/domain/usecase/login_state_use_case.dart';

import '../../domain/usecase/create_visitor_registration_use_case.dart';
import '../../domain/usecase/get_visitor_use_case.dart';

class CheckedInUseCaseBuilder {
  CheckedInUseCase make() {
    return CheckedInUseCase(CheckinFirebaseRepo());
  }
}

class DoCheckInUseCaseBuilder {
  DoCheckinUseCase make() {
    return DoCheckinUseCase(CheckinFirebaseRepo());
  }
}

class LoginStateUseCaseBuilder {
  LoginStateUseCase make() {
    return LoginStateUseCase(LoginFirebaseRepo());
  }
}
class GetLoginIdUseCaseBuilder {
  GetLoginIdUseCase make() {
    return GetLoginIdUseCase(LoginFirebaseRepo());
  }
}

class ListingAvailableUseCaseBuilder {
  GetListingAvailableUseCase make() {
    return GetListingAvailableUseCase(ListingRepoFirebase());
  }
}

class GetListingUseCaseBuilder {
  GetListingUseCase make() {
    return GetListingUseCase(ListingRepoFirebase());
  }
}

class CreateVisitorRegistrationUseCaseBuilder {
  CreateVisitorRegistrationUseCase make() {
    return CreateVisitorRegistrationUseCase(VisitorRegistrationFirebaseRepo());
  }
}

class IsVisitorRegisteredUseCaseBuilder {
  GetIsVisitorRegisteredUseCase make() {
    return GetIsVisitorRegisteredUseCase(VisitorRegistrationFirebaseRepo());
  }
}

class GetVisitorUseCaseBuilder {
  GetVisitorUseCase make() {
    return GetVisitorUseCase(VisitorRegistrationFirebaseRepo());
  }
}
