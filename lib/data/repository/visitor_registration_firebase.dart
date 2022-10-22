import 'package:property_inspect/data/dto/visitor_mapper.dart';
import 'package:property_inspect/domain/entities/optional.dart';
import 'package:property_inspect/domain/entities/visitor.dart';
import 'package:property_inspect/domain/repository/visitor_registration_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VisitorRegistrationFirebaseRepo implements VisitorRegistrationRepo {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('visitors');

  @override
  void createVisitorRegistration(Visitor visitor) {
    collection.doc(visitor.id).set(VisitorMapper().toJson(visitor));
  }

  @override
  Stream<Optional<bool>> getIsVisitorRegistered(String id) {
    return collection.doc(id).snapshots().map(
            (value) {
         return Optional(value.exists);
        });
  }
  
}