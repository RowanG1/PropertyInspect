import '../repository/checkin_repo.dart';

class CheckedInUseCase {
final CheckinRepo checkin;
  CheckedInUseCase(this.checkin);

  Stream<bool> execute(String visitorId, String propertyId) {
    return checkin.isCheckedIn(visitorId, propertyId);
  }
}