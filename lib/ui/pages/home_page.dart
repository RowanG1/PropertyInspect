import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/ui/pages/unauthenticated_page.dart';
import '../../data/utils/open_email_link.dart';
import '../controllers/login_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    final commonWidgets = [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 50, 10, 0),
        child: Text("Visitor?",
            style: TextStyle(
                fontSize: 18,
                color: Colors.orange,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
      ),
      Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text(
            "To check in to a property, you can scan the QR code at "
            "the venue.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center),
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
        padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
        child: Text("Lister?",
            style: TextStyle(
                fontSize: 18,
                color: Colors.orange,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
      ),
      Padding(
        padding: const EdgeInsets.all(40.0),
        child: const Text(
          "Would you like to list a property for inspection?",
          style: TextStyle(fontSize: 18),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          Get.toNamed(Constants.listingsRoute);
        },
        child: const Text("Go to Listings"),
      )
    ];

    return UnauthenticatedPage(
      body: FooterView(
        footer: Footer(backgroundColor: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: const Text(
                  "ABN: 67863792318",
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
                      "Contact us",
                      style: TextStyle(fontSize: 14),
                    )),
              )
            ])),
        children: [
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (loginController.getLoginState().value) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextButton(
                              onPressed: () {
                                loginController.logout();
                              },
                              child: const Text("Log out")),
                        ),
                      ],
                    )
                  ],
                  ...[
                    Center(
                      child: Column(children: [...commonWidgets]),
                    )
                  ],
                ],
              ))
        ],
      ),
    );
  }
}
