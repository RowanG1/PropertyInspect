import '../../domain/repository/checkin_repo.dart';

class CheckedInUseCase {
final CheckinRepo checkin;
  CheckedInUseCase(this.checkin);

  Stream<bool> execute(String listerId, String visitorId, String propertyId) {
    return checkin.isCheckedIn(listerId, visitorId, propertyId);
  }
}