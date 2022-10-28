import 'package:property_inspect/data/di/repo_factories.dart';
import 'package:property_inspect/data/repository/checkin_firebase_repo.dart';
import 'package:property_inspect/data/repository/lister_registration_repo_firebase.dart';
import 'package:property_inspect/data/repository/listing_repo_firebase.dart';
import 'package:property_inspect/data/repository/login_repo_firebase.dart';
import 'package:property_inspect/data/repository/visitor_registration_firebase_repo.dart';
import 'package:property_inspect/domain/repository/visitor_registration_repo.dart';
import 'package:property_inspect/domain/usecase/checked_in_use_case.dart';
import 'package:property_inspect/domain/usecase/create_lister_registration.dart';
import 'package:property_inspect/domain/usecase/create_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/do_checkin_use_case.dart';
import 'package:property_inspect/domain/usecase/get_checkins_for_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/get_is_visitor_registerd_use_case.dart';
import 'package:property_inspect/domain/usecase/get_listing_available_use_case.dart';
import 'package:property_inspect/domain/usecase/get_listing_use_case.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import 'package:property_inspect/domain/usecase/is_lister_registered_use_case.dart';
import 'package:property_inspect/domain/usecase/login_state_use_case.dart';

import '../../domain/usecase/create_visitor_registration_use_case.dart';
import '../../domain/usecase/delete_listing_use_case.dart';
import '../../domain/usecase/do_checkins_exist_use_case.dart';
import '../../domain/usecase/get_listings_use_case.dart';
import '../../domain/usecase/get_visitor_use_case.dart';

class CheckedInUseCaseFactory {
  CheckedInUseCase make() {
    return CheckedInUseCase(CheckinFirebaseRepo());
  }
}

class DoCheckInUseCaseFactory {
  DoCheckinUseCase make() {
    return DoCheckinUseCase(CheckinFirebaseRepo());
  }
}

class LoginStateUseCaseFactory {
  LoginStateUseCase make() {
    return LoginStateUseCase(LoginRepoFactory.get());
  }
}
class GetLoginIdUseCaseFactory {
  GetLoginIdUseCase make() {
    return GetLoginIdUseCase(LoginRepoFactory.get());
  }
}

class ListingAvailableUseCaseFactory {
  GetListingAvailableUseCase make() {
    return GetListingAvailableUseCase(ListingRepoFirebase());
  }
}

class GetListingUseCaseFactory {
  GetListingUseCase make() {
    return GetListingUseCase(ListingRepoFirebase());
  }
}

class GetListingsUseCaseFactory {
  GetListingsUseCase make() {
    return GetListingsUseCase(ListingRepoFirebase());
  }
}

class CreateVisitorRegistrationUseCaseFactory {
  CreateVisitorRegistrationUseCase make() {
    return CreateVisitorRegistrationUseCase(VisitorRegistrationFirebaseRepo());
  }
}

class IsVisitorRegisteredUseCaseFactory {
  GetIsVisitorRegisteredUseCase make() {
    return GetIsVisitorRegisteredUseCase(VisitorRegistrationFirebaseRepo());
  }
}

class GetVisitorUseCaseFactory {
  GetVisitorUseCase make() {
    return GetVisitorUseCase(VisitorRegistrationFirebaseRepo());
  }
}

class CreateListerRegistrationUseCaseFactory {
  CreateListerRegistrationUseCase make() {
    return CreateListerRegistrationUseCase(ListerRegistrationRepoFirebase());
  }
}

class IsListerRegisteredUseCaseFactory {
  IsListerRegisteredUseCase make() {
    return IsListerRegisteredUseCase(ListerRegistrationRepoFirebase());
  }
}

class CreateListingUseCaseFactory {
  CreateListingUseCase make() {
    return CreateListingUseCase(ListingRepoFirebase());
  }
}

class DeleteListingUseCaseFactory {
  DeleteListingUseCase make() {
    return DeleteListingUseCase(ListingRepoFirebase());
  }
}

class GetCheckinsUseCaseFactory {
  GetCheckinsForListingUseCase make() {
    return GetCheckinsForListingUseCase(CheckinFirebaseRepo());
  }
}

class DoCheckinsExistForListingUseCaseFactory {
  DoCheckinsExistForListingUseCase make() {
    return DoCheckinsExistForListingUseCase(CheckinFirebaseRepo());
  }
}