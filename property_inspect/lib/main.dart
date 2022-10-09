import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:property_inspect/ui/controllers/loginController.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' // new
    hide
        PhoneAuthProvider; // new
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'dart:async'; // new

Future<void> main() async {
  final LoginController loginController = Get.put(LoginController());

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.userChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
      loginController.setLoginState(false);
    } else {
      print('User is signed in!');
      loginController.setLoginState(true);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    loginController.isLoggedIn.listen((val) {
      // Navigate now
      val ? Get.toNamed("/home") : Get.toNamed("/signin");
    });
    //  final LoginController loginController = Get.put(LoginController());
    return GetMaterialApp(
      initialRoute: '/signin',
      getPages: [
        GetPage(
            name: '/signin',
            page: () => const SignInScreen(
                  providerConfigs: [EmailProviderConfiguration()],
                )),
        GetPage(name: '/home', page: () => const Text('Our app'))
      ],
    );
  }
}
