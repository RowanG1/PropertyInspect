import '../entities/visitor.dart';

abstract class VisitorRegistrationRepo {
  void createVisitorRegistration(Visitor visitor);
  Stream<bool> getIsVisitorRegistered(String id);
  Stream<Visitor?> getVisitor(String id);
}
