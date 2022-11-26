import '../../domain/repository/checkin_repo.dart';

class DoCheckinsExistForListingUseCase {
  final CheckinRepo checkin;
  DoCheckinsExistForListingUseCase(this.checkin);

  Stream<bool> execute(String listerId, String propertyId) {
    return checkin.getCheckins(listerId, propertyId).map((event) => event.isNotEmpty);
  }
}