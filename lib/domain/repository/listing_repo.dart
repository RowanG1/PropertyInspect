import 'package:property_inspect/domain/entities/listing.dart';

abstract class ListingRepo {
  void createListing(Listing listing);
  Future<bool> isListingAvailable(String propertyId);
}
