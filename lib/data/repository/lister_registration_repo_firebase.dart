import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:property_inspect/domain/entities/lister.dart';
import 'package:property_inspect/domain/repository/lister_registration_repo.dart';
import '../data_mappers/lister_mapper.dart';

class ListerRegistrationRepoFirebase implements ListerRegistrationRepo {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('listers');

  @override
  Future<void> createListerRegistration(Lister lister) async {
    final result = await collection.doc(lister.id).set(ListerMapper().toJson
      (lister));
    return result;
  }

  @override
  Stream<bool> getIsListerRegistered(String id) {
    return collection
        .doc(id)
        .snapshots()
        .map((value) => value.exists);
  }

}