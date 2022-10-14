import '../../domain/entities/visitor.dart';

class VisitorMapper {
  Map<String, dynamic> toJson(Visitor visitor) {
    return <String, dynamic>{'email': visitor.email, 'phone': visitor.phone};
  }

  Visitor fromJson(Map<String, dynamic> json) {
    final email = json['email'] as String;
    final phone = json['phone'] as String;
    return Visitor(email, phone);
  }
}
