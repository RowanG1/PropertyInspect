import 'package:property_inspect/domain/repository/listing_repo.dart';

import '../../domain/entities/listing.dart';

class GetListingsUseCase {
  ListingRepo listingRepo;

  GetListingsUseCase(this.listingRepo);

  Stream<List<Listing>> execute(String userId) {
    return listingRepo.getListings(userId);
  }
}
