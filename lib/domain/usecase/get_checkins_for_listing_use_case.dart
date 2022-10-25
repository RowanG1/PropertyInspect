import 'package:property_inspect/domain/entities/visitor.dart';
import '../repository/checkin_repo.dart';

class GetCheckinsForListingUseCase {
  final CheckinRepo checkin;
  GetCheckinsForListingUseCase(this.checkin);

  Stream<List<Visitor>> execute(String listerId, String propertyId) {
    return checkin.getCheckins(listerId, propertyId);
  }
}