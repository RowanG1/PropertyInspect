import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/visitor.dart';

class VisitorMapper {
  Map<String, dynamic> toJson(Visitor visitor) {
    return <String, dynamic>{
      'id': visitor.id,
      'name': visitor.name,
      'lastName': visitor.lastName,
      'email': visitor.email,
      'phone': visitor.phone,
      'suburb': visitor.suburb,
    };
  }

  Visitor? fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null) { return null; }
    final id = data['id'] as String;
    final name = data['name'] as String;
    final lastName = data['lastName'] as String;
    final email = data['email'] as String;
    final phone = data['phone'] as String;
    final suburb = data['suburb'] as String;
    return Visitor(id: id, name: name, lastName: lastName, email: email, phone: phone, suburb: suburb);
  }
}
