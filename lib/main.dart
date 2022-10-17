import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/repository/analytics_firebase.dart';
import 'package:property_inspect/data/repository/login_state_firebase.dart';
import 'package:property_inspect/domain/usecase/analytics_usecase.dart';
import 'package:property_inspect/domain/usecase/login_state_use_case.dart';
import 'package:property_inspect/domain/usecase/logout_use_case.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/ui/controllers/continue_referrer_controller.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/pages/signin_container.dart';
import 'package:property_inspect/ui/pages/checkin_page.dart';
import 'package:property_inspect/ui/pages/create_listing_page.dart';
import 'package:property_inspect/ui/pages/home_page.dart';
import 'package:property_inspect/ui/pages/listing_page.dart';
import 'package:property_inspect/ui/pages/visitor_registration_page.dart';
import 'data/repository/logout_firebase.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'dart:async'; // new

Future<void> main() async {
  await initFirebase();
  initLoginController();
  setupLogout();
  Get.put(ContinueReferrerController());
  runApp(const MyApp());
}

initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

setupLogout() {
  final loginController = Get.find<LoginController>();

  loginController.getLoginState().listen((val) {
    if (!val)
      Get.toNamed(Constants.signInRoute);
    });
}

initLoginController() {
  final LoginStateUseCase loginStateUseCase =
      LoginStateUseCase(LoginFirebaseRepo());
  final LogoutUseCase logoutUseCase = LogoutUseCase(LogoutFirebaseRepo());
  final AnalyticsUseCase analyticsUseCase =
      AnalyticsUseCase(AnalyticsFirebaseRepo());

  final controller = Get.put(LoginController(loginStateUseCase, logoutUseCase,
      analyticsUseCase));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Constants.signInRoute,
      getPages: [
        GetPage(
            name: Constants.signInRoute, page: () => SignInContainer()),
        GetPage(
            name: Constants.userRegistrationRoute,
            page: () => VisitorRegistrationPage()),
        GetPage(
            name: Constants.createListingRoute,
            page: () => CreateListingPage()),
        GetPage(
            name: Constants.checkinRoute,
            page: () =>  CheckinPage()),
        GetPage(name: Constants.homeRoute, page: () => const HomePage()),
        GetPage(name: Constants.listingRoute, page: () => const ListingPage()),
      ],
    );
  }
}
