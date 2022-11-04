class Listing {
  String? id;
  String userId;
  String address;
  String suburb;
  String postCode;
  String phone;
  DateTime? createdAt;

  Listing({this.id, required this.userId, required this.address, required this.suburb, required this
      .postCode, required this.phone, this.createdAt});
}