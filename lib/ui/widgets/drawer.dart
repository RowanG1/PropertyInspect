import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:property_inspect/ui/controllers/PackageController.dart';
import 'package:property_inspect/ui/widgets/drawer_button.dart';
import '../../data/utils/open_email_link.dart';
import '../../domain/constants.dart';
import '../controllers/login_controller.dart';

class SideDrawer extends StatelessWidget {
  SideDrawer({Key? key}) : super(key: key);
  final loginController = Get.find<LoginController>();
  final packageController = Get.find<PackageController>();

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        children: [
          Obx(() => Expanded(
                  child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Property Checkin', style: TextStyle(fontSize:
                  18),),
                ),
                if (!currentRouteIsHome())
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
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
                if (loginController.getLoginState().value == true)
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: DrawerButton(iconData: Icons.home, label: "Log out",
                      onPressed: () {
                      loginController.logout();
                      goHomeAsync();
                    },),
                  ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: DrawerButton(iconData: Icons.contact_mail,
                        label: Constants.privacyPolicyLabel, onPressed: () {
                         Get.toNamed(Constants.privacyPolicyRouteKey);
                        },),
                    )
              ]))),
    Obx(() => Text(getPackageText(packageController.getPackageInfo()))),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              color: Colors.black12,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
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

  String getPackageText(PackageInfo? packageInfo) {
    return 'Version number: ' + (packageInfo?.version ?? '') +  ', Build '
        'number: ' + (packageInfo?.buildNumber ?? '');
  }

  // To avoid timing bug where snackbar is false triggered, do this async.
  void goHomeAsync() async {
    Get.offAllNamed(Constants.homeRoute);
  }

  bool currentRouteIsHome() {
    final currentRoute = Get.currentRoute;
    print("Current route is $currentRoute");
    return currentRoute == Constants.homeRoute;
  }
}
