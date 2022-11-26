import 'package:property_inspect/domain/entities/visitor.dart';
import 'package:property_inspect/domain/repository/visitor_registration_repo.dart';

class GetVisitorUseCase {
  VisitorRegistrationRepo visitorRepo;

  GetVisitorUseCase(this.visitorRepo);

  Stream<Visitor?> execute(String id) {
    return visitorRepo.getVisitor(id);
  }
}
