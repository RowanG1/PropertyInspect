import 'package:firebase_auth/firebase_auth.dart';
import 'package:property_inspect/domain/repository/logout_repo.dart';

class LogoutFirebaseRepo implements LogoutRepo {
  @override
  logout() {
    FirebaseAuth.instance.signOut();
  }
}
