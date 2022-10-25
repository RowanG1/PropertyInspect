import '../entities/visitor.dart';
import '../repository/checkin_repo.dart';

class DoCheckinUseCase {
  final CheckinRepo checkin;
  DoCheckinUseCase(this.checkin);

 void execute(String visitorId, String propertyId, String listerId, Visitor
 visitor) {
    return checkin.createCheckin(visitorId, propertyId, listerId, visitor);
  }
}