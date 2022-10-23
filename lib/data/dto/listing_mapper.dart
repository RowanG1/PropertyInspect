import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/listing.dart';

class ListingMapper {
  Map<String, dynamic> toJson(Listing listing) {
    return <String, dynamic>{
      'address': listing.address,
      'suburb': listing.suburb,
      'postCode': listing.postCode,
      'phone': listing.phone,
    };
  }

  Listing fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final address = data['address'] as String;
    final suburb = data['suburb'] as String;
    final postCode = data['postCode'] as String;
    final phone = data['phone'] as String;
    return Listing(address, suburb, postCode, phone);
  }
}
