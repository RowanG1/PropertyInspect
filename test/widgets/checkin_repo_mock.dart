import 'package:property_inspect/domain/entities/visitor.dart';
import 'package:property_inspect/domain/repository/checkin_repo.dart';
import 'package:rxdart/rxdart.dart';

class CheckinRepoMock extends CheckinRepo {
  BehaviorSubject<bool> isChecked = BehaviorSubject.seeded(false);

  @override
  void createCheckin(String visitorId, String propertyId, String listerId, Visitor visitor) {
    isChecked.value = true;
  }

  @override
  Stream<List<Visitor>> getCheckins(String listerId, String propertyId) {
    // TODO: implement getCheckins
    throw UnimplementedError();
  }

  @override
  Stream<bool> isCheckedIn(String listerId, String visitorId, String propertyId) {
    return isChecked.stream;
  }

}