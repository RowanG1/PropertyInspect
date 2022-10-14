import 'package:property_inspect/data/dto/visitor_mapper.dart';
import 'package:property_inspect/domain/entities/visitor.dart';
import 'package:property_inspect/domain/repository/visitor_registration.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class VisitorRegistrationFirebase implements VisitorRegistration {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('visitors');

  @override
  void createVisitorRegistration(Visitor visitor) {
    collection.add(VisitorMapper().toJson(visitor));
  }
  
}