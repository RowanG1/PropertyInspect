import 'package:get/get.dart';

class ContinueReferrerController extends GetxController {
  String? referrerRoute;

  void setReferrer(String route) {
    referrerRoute = route;
    update();
  }
  ContinueReferrerController();
}