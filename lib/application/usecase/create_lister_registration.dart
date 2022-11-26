import 'package:property_inspect/domain/repository/lister_registration_repo.dart';
import '../../domain/entities/lister.dart';

class CreateListerRegistrationUseCase {
  final ListerRegistrationRepo _listerRepo;

  CreateListerRegistrationUseCase(this._listerRepo);

  Future<void> execute(Lister lister) async {
    return await _listerRepo.createListerRegistration(lister);
  }
}