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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...[
            Center(
              child: Column(children: [...commonWidgets]),
            )
          ],
        ],
      ),
    );
  }
}
