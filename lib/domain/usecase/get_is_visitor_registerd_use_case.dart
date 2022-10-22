import 'package:property_inspect/domain/entities/optional.dart';
import 'package:property_inspect/domain/repository/visitor_registration_repo.dart';

class GetIsVisitorRegisteredUseCase {
  final VisitorRegistrationRepo visitorRepo;

  GetIsVisitorRegisteredUseCase(this.visitorRepo);

  Stream<Optional<bool>> execute(String id) {
    return visitorRepo.getIsVisitorRegistered(id);
  }
}