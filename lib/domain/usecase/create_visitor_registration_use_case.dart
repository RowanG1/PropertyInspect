import 'package:property_inspect/domain/entities/visitor.dart';
import 'package:property_inspect/domain/repository/visitor_registration_repo.dart';

class CreateVisitorRegistrationUseCase {
  VisitorRegistrationRepo visitorRegistrationRepo;

  CreateVisitorRegistrationUseCase(this.visitorRegistrationRepo);

  execute(String name, String lastName, String email, String phone,
      String suburb) {
    final visitor = Visitor(name, lastName, email, phone, suburb);
    return visitorRegistrationRepo.createVisitorRegistration(visitor);
  }
}
