import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/data/di/use_case_factories.dart';
import 'package:property_inspect/data/repository/analytics_firebase_repo.dart';
import 'package:property_inspect/data/repository/login_repo_firebase.dart';
import 'package:property_inspect/domain/usecase/analytics_use_case.dart';
import 'package:property_inspect/domain/usecase/login_state_use_case.dart';
import 'package:property_inspect/domain/usecase/logout_use_case.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/ui/controllers/PackageController.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/controllers/test_mode_controller.dart';
import 'package:property_inspect/ui/pages/checkin_page.dart';
import 'package:property_inspect/ui/pages/checkins_page.dart';
import 'package:property_inspect/ui/pages/create_listing_page.dart';
import 'package:property_inspect/ui/pages/home_page.dart';
import 'package:property_inspect/ui/pages/listing_page.dart';
import 'package:property_inspect/ui/pages/listings_page.dart';
import 'package:property_inspect/ui/pages/privacy_policy_page.dart';
import 'package:property_inspect/ui/pages/signin_route_home.dart';
import 'data/di/controllers_factories.dart';
import 'data/repository/logout_firebase_repo.dart';
import 'dart:async'; // new

Future<void> main() async {
  mainSetup();
}

mainSetup() async {
  WidgetsFlutterBinding.ensureInitialized();
  commonFirebaseUISetup();
  initLoginController();
  Get.put(PackageController());
  Get.put(TestModeController());
  runApp(const MyApp());
}

commonFirebaseUISetup() {
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);
}

initLoginController() {
  final LoginStateUseCase loginStateUseCase = LoginStateUseCase(LoginFirebaseRepo());
  final LogoutUseCase logoutUseCase = LogoutUseCase(LogoutFirebaseRepo());
  final AnalyticsUseCase analyticsUseCase = AnalyticsUseCase(AnalyticsFirebaseRepo());

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
            page: () => CreateListingPage(
                loginController: Get.find(),
                createListingController: CreateListingControllerFactory().make(),
                analyticsUseCase: AnalyticsUseCaseFactory().make(),
                listerRegistrationController: ListerRegistrationControllerFactory().make(),
                listerFlowController: ListerFlowControllerFactory().make())),
        GetPage(
            name: Constants.listingsRoute,
            page: () => ListingsPage(
                listerRegistrationController: ListerRegistrationControllerFactory().make(),
                listerFlowController: ListerFlowControllerFactory().make(),
                analyticsUseCase: AnalyticsUseCaseFactory().make())),
        GetPage(
            name: Constants.checkinRoute,
            page: () => CheckinPage(
                  analyticsUseCase: AnalyticsUseCaseFactory().make(),
                  loginController: Get.find(),
                  visitorFlowController: VisitorFlowControllerFactory().make(),
                  visitorRegistrationController: VisitorRegistrationControllerFactory().make(),
                  checkinController: CheckinControllerFactory().make(),
                )),
        GetPage(
            name: Constants.checkinsRoute,
            page: () => CheckinsPage(
                listerRegistrationController: ListerRegistrationControllerFactory().make(),
                listerFlowController: ListerFlowControllerFactory().make(),
                analyticsUseCase: AnalyticsUseCaseFactory().make())),
        GetPage(
            name: Constants.listingRoute,
            page: () => ListingPage(
                listerRegistrationController: ListerRegistrationControllerFactory().make(),
                listerFlowController: ListerFlowControllerFactory().make(),
                analyticsUseCase: AnalyticsUseCaseFactory().make())),
        GetPage(name: Constants.privacyPolicyRouteKey, page: () => PrivacyPolicyPage()),
      ],
    );
  }
}
