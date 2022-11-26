import 'package:property_inspect/domain/repository/visitor_registration_repo.dart';

class GetIsVisitorRegisteredUseCase {
  final VisitorRegistrationRepo visitorRepo;

  GetIsVisitorRegisteredUseCase(this.visitorRepo);

  Stream<bool> execute(String id) {
    return visitorRepo.getIsVisitorRegistered(id);
  }
}