import 'package:property_inspect/domain/repository/listing_repo.dart';

import '../entities/listing.dart';

class CreateListingUseCase {
  ListingRepo createListingRepo;

  CreateListingUseCase(this.createListingRepo);

  Future<void> execute(String userId, String address, String suburb, String
  postCode,
      String
  phone) {
    final listing = Listing(userId: userId, address: address, suburb: suburb,
        postCode: postCode,
        phone: phone);
    return createListingRepo.createListing(listing);
  }
}
