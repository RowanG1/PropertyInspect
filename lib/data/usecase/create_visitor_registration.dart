import 'package:property_inspect/domain/entities/visitor.dart';
import 'package:property_inspect/domain/repository/visitor_registration.dart';

class CreateVisitorRegistrationUseCase {
  VisitorRegistration visitorRegistrationRepo;

  CreateVisitorRegistrationUseCase(this.visitorRegistrationRepo);

  execute(String email, String phone) {
    final visitor = Visitor(email, phone);
    return visitorRegistrationRepo.createVisitorRegistration(visitor);
  }
}
