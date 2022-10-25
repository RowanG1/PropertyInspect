import '../../data/types/optional.dart';
import '../entities/visitor.dart';

abstract class VisitorRegistrationRepo {
  void createVisitorRegistration(Visitor visitor);
  Stream<Optional<bool>> getIsVisitorRegistered(String id);
  Stream<Visitor?> getVisitor(String id);
}
