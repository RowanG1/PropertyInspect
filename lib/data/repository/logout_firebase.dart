import 'package:firebase_auth/firebase_auth.dart';
import 'package:property_inspect/domain/repository/logout.dart';

class LogoutFirebaseRepo implements Logout {
  @override
  logout() {
    FirebaseAuth.instance.signOut();
  }
}
