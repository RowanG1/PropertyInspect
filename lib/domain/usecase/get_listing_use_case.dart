import 'package:property_inspect/domain/repository/listing_repo.dart';

import '../entities/listing.dart';

class GetListingUseCase {
  ListingRepo listingRepo;

  GetListingUseCase(this.listingRepo);

  Stream<Listing> execute(String propertyId) {
    return listingRepo.getListing(propertyId);
  }
}
