import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/types/env.dart';
import 'domain/constants.dart';
import 'main_common.dart';
import 'firebase_options_prod.dart';

Future<void> main() async {
  await initFirebase();
  setupEnv();
  mainSetup();
}

void setupEnv() {
  Get.put(Env(appTitle: "Property Check-in", env: Constants.prodEnv));
}

initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}