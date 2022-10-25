import '../entities/visitor.dart';

abstract class CheckinRepo {
  void createCheckin(String visitorId, String propertyId, String listerId,
  Visitor visitor);
  Stream<bool> isCheckedIn(String visitorId, String propertyId);
  Stream<List<Visitor>> getCheckins(String listerId, String
  propertyId);
}
