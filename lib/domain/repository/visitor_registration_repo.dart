import '../entities/optional.dart';
import '../entities/visitor.dart';

abstract class VisitorRegistrationRepo {
  void createVisitorRegistration(Visitor visitor);
  Stream<Optional<bool>> getIsVisitorRegistered(String id);
}
