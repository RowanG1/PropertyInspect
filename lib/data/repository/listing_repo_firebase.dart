import 'package:get/get.dart';
import 'package:property_inspect/domain/entities/listing.dart';
import 'package:property_inspect/domain/repository/listing_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../dto/listing_mapper.dart';

class ListingRepoFirebase implements ListingRepo {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('listings');

  @override
  Future<void> createListing(Listing listing) {
    return collection.add(ListingMapper().toJson(listing));
  }

  @override
  Stream<bool> isListingAvailable(String propertyId) {
    return collection
        .doc(propertyId)
        .snapshots()
        .map((value) => value.exists);
  }

  @override
  Stream<Listing?> getListing(listingId) {
    return collection
        .doc(listingId)
        .snapshots().map((event) {
          return ListingMapper().fromSnapshot(event);
    });
  }

  @override
  Stream<List<Listing>> getListings(userId) {
    return collection
        .where("userId", isEqualTo: userId)
        .snapshots().map((event) {
          return event.docs.map((e) => ListingMapper().fromSnapshot(e)).where
            ((element) => element != null).map((e) => e!)
              .toList();
    });
  }
}