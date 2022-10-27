import 'package:flutter/material.dart';

class UnauthenticatedPage extends StatelessWidget {
  final Widget body;

  const UnauthenticatedPage({required this.body, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Property checkin")), body: body);
  }
}
