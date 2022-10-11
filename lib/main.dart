import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/repository/analytics_firebase.dart';
import 'package:property_inspect/data/repository/login_state_firebase.dart';
import 'package:property_inspect/data/usecase/analytics_usecase.dart';
import 'package:property_inspect/data/usecase/login_state_use_case.dart';
import 'package:property_inspect/data/usecase/logout_use_case.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/pages/home_page.dart';
import 'package:property_inspect/ui/pages/listing_page.dart';
import 'data/repository/logout_firebase.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'dart:async'; // new

Future<void> main() async {
  await initFirebase();
  initLoginController();
  runApp(const MyApp());
}

initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

initLoginController() {
  final LoginStateUseCase loginStateUseCase =
      LoginStateUseCase(LoginFirebaseRepo());
  final LogoutUseCase logoutUseCase = LogoutUseCase(LogoutFirebaseRepo());
  final AnalyticsUseCase analyticsUseCase =
      AnalyticsUseCase(AnalyticsFirebaseRepo());

  Get.put(LoginController(loginStateUseCase, logoutUseCase, analyticsUseCase));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    loginController.getLoginState().listen((val) {
      if (val) {
        loginController.logAnalyticsLoggedIn();
      }
      val
          ? Get.toNamed(Constants.homeRoute)
          : Get.toNamed(Constants.signInRoute);
    });

    return GetMaterialApp(
      initialRoute: Constants.signInRoute,
      getPages: [
        GetPage(
            name: Constants.signInRoute,
            page: () => const SignInScreen(
                  providerConfigs: [EmailProviderConfiguration()],
                )),
        GetPage(
            name: Constants.homeRoute,
            page: () => TextButton(
                  onPressed: () {
                    loginController.logout();
                  },
                  child: const HomePage(),
                )),
        GetPage(
            name: Constants.listingRoute,
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
