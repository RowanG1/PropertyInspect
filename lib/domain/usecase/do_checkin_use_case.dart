import '../repository/checkin_repo.dart';

class DoCheckinUseCase {
  final CheckinRepo checkin;
  DoCheckinUseCase(this.checkin);

 void execute(String visitorId, String propertyId) {
    return checkin.createCheckin(visitorId, propertyId);
  }
}