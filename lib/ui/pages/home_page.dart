import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/ui/pages/unauthenticated_page.dart';

import '../controllers/login_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    final commonWidgets = [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text("Property Inspector", style:
        TextStyle(fontSize: 18, color: Colors.orange, fontWeight: FontWeight.bold),
            textAlign: TextAlign
            .center),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text("Are you a visitor? \nYou can scan your QR code at the "
            "venue.", style:
        TextStyle(fontSize: 18), textAlign: TextAlign.center),
      ),
      Padding(
        padding: const EdgeInsets.all(18.0),
        child: const Divider(
          thickness: 1.5,
          indent: 20,
          endIndent: 20,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(40.0),
        child: const Text("Would you like to list a property for inspection?",
          style:
        TextStyle(fontSize: 18),),
      ),
      ElevatedButton(
        onPressed: () {
          Get.toNamed(Constants.listingsRoute);
        },
        child: const Text("Go to Listings"),
      )
    ];

    return UnauthenticatedPage(
      body: Obx(() => Column( crossAxisAlignment: CrossAxisAlignment.start,
        children: [if (loginController.getLoginState().value) ...
          [Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
                onPressed: () {
                  loginController.logout();
                },
                child: const Text("Log out")),
          )], ... [Center(
            child: Column(children: [
              ...commonWidgets
            ]),
          )],
        ],
      )),
    );
  }
}
