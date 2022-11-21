import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:property_inspect/domain/entities/visitor.dart';
import 'package:property_inspect/domain/repository/checkin_repo.dart';
import '../data_mappers/visitor_mapper.dart';

class CheckinFirebaseRepo implements CheckinRepo {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('checkins');

  @override
  void createCheckin(
      String visitorId, String propertyId, String listerId, Visitor visitor) {
    collection
        .doc(listerId)
        .collection(propertyId)
        .doc(visitorId)
        .set(VisitorMapper().toJson(visitor));
  }

  @override
  Stream<bool> isCheckedIn(
      String listerId, String visitorId, String propertyId) {
    return collection
        .doc(listerId)
        .collection(propertyId)
        .doc(visitorId)
        .snapshots()
        .map((event) => event.exists);
  }

  @override
  Stream<List<Visitor>> getCheckins(String listerId, String propertyId) {
    return collection.doc(listerId).collection(propertyId).snapshots().map(
        (event) => event.docs
            .map((e) => VisitorMapper().fromSnapshot(e))
            .where((element) => element != null)
            .map((e) => e!)
            .toList());
  }
}
