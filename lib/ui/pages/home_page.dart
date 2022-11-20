import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/constants.dart';
import 'package:property_inspect/ui/pages/unauthenticated_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonWidgets = [
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 50, 10, 0),
        child: Text("Visitor?",
            style: TextStyle(
                fontSize: 18,
                color: Colors.orange,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
      ),
      const Padding(
        padding: EdgeInsets.all(30.0),
        child: Text(
            "To check in to a property, you can scan the QR code at "
            "the venue.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center),
      ),
      const Padding(
        padding: EdgeInsets.all(18.0),
        child: Divider(
          thickness: 0.9,
          indent: 20,
          endIndent: 20,
          color: Colors.black,
        ),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
        child: Text("Lister?",
            style: TextStyle(
                fontSize: 18,
                color: Colors.orange,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
      ),
      const Padding(
        padding: EdgeInsets.all(40.0),
        child: Text(
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...[
              Center(
                child: Column(children: [...commonWidgets]),
              )
            ],
          ],
        ),
      ),
    );
  }
}
