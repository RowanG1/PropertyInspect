import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/widgets/drawer_button.dart';
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
                    padding: const EdgeInsets.all(15.0),
                    child: DrawerButton(iconData: Icons.home, label: "Go "
                        "home", onPressed: () {
                      Get.offAllNamed(Constants.homeRoute);
                    },),
                  ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: DrawerButton(iconData: Icons.contact_mail,
                        label: Constants.contactUsLabel, onPressed: () {
                        EmailLink().openEmailLink(Constants.contactEmail);
                      },),
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
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: const Text(
                        Constants.abnLabel,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
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
