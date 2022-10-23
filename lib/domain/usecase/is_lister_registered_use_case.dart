import 'package:property_inspect/domain/repository/lister_registration_repo.dart';
import '../entities/lister.dart';

class IsListerRegisteredUseCase {
  ListerRegistrationRepo _listerRepo;

  IsListerRegisteredUseCase(this._listerRepo);

 Stream<bool> execute(String userId) {
    return _listerRepo.getIsListerRegistered(userId);
  }
}