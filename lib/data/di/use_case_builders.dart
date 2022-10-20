import 'package:property_inspect/data/repository/checkin_firebase_repo.dart';
import 'package:property_inspect/data/repository/listing_repo_firebase.dart';
import 'package:property_inspect/data/repository/login_repo_firebase.dart';
import 'package:property_inspect/domain/usecase/checked_in_use_case.dart';
import 'package:property_inspect/domain/usecase/get_listing_available_use_case.dart';
import 'package:property_inspect/domain/usecase/get_login_id_use_case.dart';
import 'package:property_inspect/domain/usecase/login_state_use_case.dart';

class CheckedInUseCaseBuilder {
  CheckedInUseCase make() {
    return CheckedInUseCase(CheckinFirebaseRepo());
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

