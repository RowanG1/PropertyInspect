import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/listing.dart';

class ListingMapper {
  Map<String, dynamic> toJson(Listing listing) {
    return <String, dynamic>{
      'userId': listing.userId,
      'address': listing.address,
      'suburb': listing.suburb,
      'postCode': listing.postCode,
      'phone': listing.phone,
    };
  }

  Listing? fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      return null;
    }
    final userId = data['userId'] as String;
    final address = data['address'] as String;
    final suburb = data['suburb'] as String;
    final postCode = data['postCode'] as String;
    final phone = data['phone'] as String;
    return Listing(id: snapshot.id, userId: userId, address: address, suburb:
    suburb,
        postCode: postCode,
        phone: phone);
  }
}
