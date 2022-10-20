import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:property_inspect/domain/repository/checkin_repo.dart';

import '../dto/checkin_mapper.dart';

class CheckinFirebaseRepo implements CheckinRepo {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('checkin');

  @override
  void createCheckin(String visitorId, String propertyId) {
    collection.add(CheckinMapper().toJson(visitorId, propertyId));
  }

  @override
  Stream<bool> isCheckedIn(String visitorId, String propertyId) {
    return collection.where("visitorId", isEqualTo: visitorId)
        .where
      ("propertyId",
        isEqualTo: propertyId).snapshots().map((event) => event.docs
        .isNotEmpty);
  }
}