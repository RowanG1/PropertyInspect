import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/lister.dart';

class ListerMapper {
  Map<String, dynamic> toJson(Lister lister) {
    return <String, dynamic>{
      'id': lister.id,
      'company': lister.company,
      'name': lister.name,
      'lastName': lister.lastName,
      'email': lister.email,
      'phone': lister.phone
    };
  }

  Lister fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final id = data['id'] as String;
    final company = data['company'] as String;
    final name = data['name'] as String;
    final lastName = data['lastName'] as String;
    final email = data['email'] as String;
    final phone = data['phone'] as String;
    return Lister(
        id: id,
        name: name,
        lastName: lastName,
        company: company,
        email: email,
        phone: phone);
  }
}
