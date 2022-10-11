import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/repository/analytics_firebase.dart';
import 'package:property_inspect/data/repository/login_state_firebase.dart';
import 'package:property_inspect/data/usecase/analytics_usecase.dart';
import 'package:property_inspect/data/usecase/login_state_use_case.dart';
import 'package:property_inspect/data/usecase/logout_use_case.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/pages/home_page.dart';
import 'package:property_inspect/ui/pages/listing_page.dart';
import 'data/repository/logout_firebase.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' // new
    hide
        PhoneAuthProvider; // new
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:async'; // new

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final LoginStateUseCase loginStateUseCase =
      LoginStateUseCase(LoginFirebaseRepo());
  final LogoutUseCase logoutUseCase = LogoutUseCase(LogoutFirebaseRepo());
  final AnalyticsUseCase analyticsUseCase =
      AnalyticsUseCase(AnalyticsFirebaseRepo());
  Get.put(LoginController(loginStateUseCase, logoutUseCase, analyticsUseCase));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    loginController.getLoginState().listen((val) {
      if (val) {
        loginController.logEventLoggedIn();
      }
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
        GetPage(
            name: '/home',
            page: () => TextButton(
                  onPressed: () {
                    loginController.logout();
                  },
                  child: const HomePage(),
                )),
        GetPage(
            name: '/listing',
            page: () => TextButton(
                  onPressed: () {
                    loginController.logout();
                  },
                  child: const ListingPage(),
                )),
      ],
    );
  }
}
