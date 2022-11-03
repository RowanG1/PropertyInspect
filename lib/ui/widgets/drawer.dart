import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/utils/open_email_link.dart';
import '../../domain/constants.dart';
import '../controllers/login_controller.dart';

class SideDrawer extends StatelessWidget {
  SideDrawer({Key? key}) : super(key: key);
  final loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Obx(() => Expanded(
                  child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Property Checkin'),
                ),
                if (!currentRouteIsHome())
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.home),
                      onPressed: () {
                        Get.offAllNamed(Constants.homeRoute);
                      },
                      label: Text('Go home'),
                    ),
                  ),
                if (loginController.getLoginState().value)
                  TextButton(
                      onPressed: () {
                        Get.offAllNamed(Constants.homeRoute);
                        loginController.logout();
                      },
                      child: const Text("Log out"))
              ]))),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              color: Colors.black12,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: const Text(
                        Constants.abnLabel,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TextButton(
                          onPressed: () {
                            EmailLink().openEmailLink(Constants.contactEmail);
                          },
                          child: Text(
                            Constants.contactUsLabel,
                            style: TextStyle(fontSize: 14),
                          )),
                    )
                  ]),
            ),
          )
        ],
      ), // Populate the Drawer in the next step.
    );
  }

  bool currentRouteIsHome() {
    final currentRoute = Get.currentRoute;
    print("Current route is $currentRoute");
    return currentRoute == Constants.homeRoute;
  }
}
