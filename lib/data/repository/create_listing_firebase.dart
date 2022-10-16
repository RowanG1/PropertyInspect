import 'package:property_inspect/domain/entities/listing.dart';
import 'package:property_inspect/domain/repository/create_listing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../dto/listing_mapper.dart';

class CreateListingFirebase implements CreateListing {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('listings');

  @override
  void createListing(Listing listing) {
    collection.add(ListingMapper().toJson(listing));
  }

}