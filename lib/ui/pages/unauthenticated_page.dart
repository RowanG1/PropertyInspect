import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/constants.dart';

class UnauthenticatedPage extends StatelessWidget {
  final Widget body;

  const UnauthenticatedPage({required this.body, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
        child: Scaffold(
            appBar: AppBar(
                title: Text("Property"
                    " checkin"),
                leading: IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.white,
                  onPressed: () {
                    Get.toNamed(Constants.homeRoute);
                  },
                )),
            body: body));
  }
}
