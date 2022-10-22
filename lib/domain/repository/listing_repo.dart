import 'package:property_inspect/domain/entities/listing.dart';

import '../../data/types/optional.dart';

abstract class ListingRepo {
  void createListing(Listing listing);
  Stream<bool> isListingAvailable(String propertyId);
  Stream<Listing> getListing(listingId);
}
