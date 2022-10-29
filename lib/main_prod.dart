import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'main_common.dart';
import 'firebase_options_prod.dart';

Future<void> main() async {
  await initFirebase();
  mainSetup();
}

initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}