abstract class CheckinRepo {
  void createCheckin(String visitorId, String propertyId);
  Stream<bool> isCheckedIn(String visitorId, String propertyId);
}
