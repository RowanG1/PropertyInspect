import 'package:property_inspect/domain/entities/listing.dart';

abstract class ListingRepo {
  Future<void> createListing(Listing listing);
  Stream<bool> isListingAvailable(String propertyId);
  Stream<Listing?> getListing(listingId);
  Stream<List<Listing>> getListings(userId);
}
