import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'data/types/env.dart';
import 'main_common.dart';
import 'firebase_options_staging.dart';

Future<void> main() async {
  await initFirebase();
  setupEnv();
  mainSetup();
}

void setupEnv() {
  Get.put(Env(appTitle: "Property Inspect (staging)"));
}

initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
