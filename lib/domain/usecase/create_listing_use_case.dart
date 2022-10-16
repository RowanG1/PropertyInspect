import 'package:property_inspect/domain/entities/visitor.dart';
import 'package:property_inspect/domain/repository/create_listing.dart';

import '../entities/listing.dart';

class CreateListingUseCase {
  CreateListing createListingRepo;

  CreateListingUseCase(this.createListingRepo);

  execute(String address, String suburb, String postCode, String phone) {
    final listing = Listing(address, suburb, postCode, phone);
    return createListingRepo.createListing(listing);
  }
}
