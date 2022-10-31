import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/types/env.dart';

class UnauthenticatedPage extends StatelessWidget {
  final Widget body;

  const UnauthenticatedPage({required this.body, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
        child: Scaffold(
            appBar: AppBar(
                title: Text(Get.find<Env>().appTitle),
                ),
            body: body));
  }
}
