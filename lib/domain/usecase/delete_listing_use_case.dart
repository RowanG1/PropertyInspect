import '../repository/listing_repo.dart';

class DeleteListingUseCase {
  ListingRepo listingRepo;

  DeleteListingUseCase(this.listingRepo);

  Future<void> execute(String listingId) {
    return listingRepo.deleteListing(listingId);
  }
}
