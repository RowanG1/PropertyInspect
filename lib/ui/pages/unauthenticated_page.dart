import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnauthenticatedPage extends StatelessWidget {
  final Widget body;

  const UnauthenticatedPage({required this.body, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body);
  }
}
