import 'package:property_inspect/domain/entities/visitor.dart';
import 'package:property_inspect/domain/repository/visitor_registration_repo.dart';
import 'package:rxdart/rxdart.dart';

class VisitorRegistrationRepoMock extends VisitorRegistrationRepo {
  final BehaviorSubject<bool> _isRegistered = BehaviorSubject.seeded(false);

  @override
  void createVisitorRegistration(Visitor visitor) {
    _isRegistered.value = true;
  }

  @override
  Stream<bool> getIsVisitorRegistered(String id) {
    return _isRegistered.stream;
  }

  @override
  Stream<Visitor?> getVisitor(String id) {
    return Stream.value(Visitor(
        id: '345',
        name: 'Rowan',
        lastName: 'Gont',
        email: 'rgon@gm.com',
        phone: '2345',
        suburb: 'Pyrmont'));
  }
}
