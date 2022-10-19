import 'package:property_inspect/domain/repository/listing_repo.dart';

class GetListingAvailableUseCase {
  ListingRepo listingRepo;

  GetListingAvailableUseCase(this.listingRepo);

  execute(String propertyId) {
    return listingRepo.isListingAvailable(propertyId);
  }
}
