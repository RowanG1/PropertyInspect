import 'package:property_inspect/domain/repository/listing_repo.dart';

import '../entities/listing.dart';

class CreateListingUseCase {
  ListingRepo createListingRepo;

  CreateListingUseCase(this.createListingRepo);

  execute(String userId, String address, String suburb, String postCode, String
  phone) {
    final listing = Listing(userId, address, suburb, postCode, phone);
    return createListingRepo.createListing(listing);
  }
}
