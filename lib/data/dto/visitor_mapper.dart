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

  Visitor fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final name = json['name'] as String;
    final lastName = json['lastName'] as String;
    final email = json['email'] as String;
    final phone = json['phone'] as String;
    final suburb = json['suburb'] as String;
    return Visitor(id, name, lastName, email, phone, suburb);
  }
}
