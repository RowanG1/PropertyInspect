import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/utils/open_email_link.dart';
import '../../domain/constants.dart';

class PageWithFooter extends StatelessWidget {
  final Widget body;
  PageWithFooter({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: body),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Container(color: Colors.black12,
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
    ]);
  }
}
