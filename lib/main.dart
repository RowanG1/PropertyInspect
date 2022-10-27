import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/repository/analytics_firebase_repo.dart';
import 'package:property_inspect/data/repository/login_repo_firebase.dart';
import 'package:property_inspect/domain/usecase/analytics_use_case.dart';
import 'package:property_inspect/domain/usecase/login_state_use_case.dart';
import 'package:property_inspect/domain/usecase/logout_use_case.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/pages/checkin_page.dart';
import 'package:property_inspect/ui/pages/checkins_page.dart';
import 'package:property_inspect/ui/pages/create_listing_page.dart';
import 'package:property_inspect/ui/pages/home_page.dart';
import 'package:property_inspect/ui/pages/listing_page.dart';
import 'package:property_inspect/ui/pages/listings_page.dart';
import 'package:property_inspect/ui/pages/signin_route_home.dart';
import 'package:property_inspect/ui/pages/visitor_registration_page.dart';
import 'data/repository/logout_firebase_repo.dart';
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
    return GetMaterialApp(
      initialRoute: Constants.homeRoute,
      getPages: [
        GetPage(name: Constants.homeRoute, page: () => const HomePage()),
        GetPage(name: Constants.signInRoute, page: () => SignInRouteHome()),
        GetPage(
            name: Constants.createListingRoute,
            page: () => CreateListingPage()),
        GetPage(name: Constants.listingsRoute, page: () => ListingsPage()),
        GetPage(name: Constants.checkinRoute, page: () => CheckinPage()),
        GetPage(name: Constants.checkinsRoute, page: () => CheckinsPage()),
        GetPage(name: Constants.listingRoute, page: () => ListingPage()),
      ],
    );
  }
}
