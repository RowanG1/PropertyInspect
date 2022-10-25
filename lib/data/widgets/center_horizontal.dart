import 'package:flutter/material.dart';

class CenterHorizontal extends StatelessWidget {

  CenterHorizontal({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.center,children: [child]);
}