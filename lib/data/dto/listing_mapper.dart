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

  Listing fromJson(Map<String, dynamic> json) {
    final address = json['address'] as String;
    final suburb = json['suburb'] as String;
    final postCode = json['postCode'] as String;
    final phone = json['phone'] as String;
    return Listing(address, suburb, postCode, phone);
  }
}
