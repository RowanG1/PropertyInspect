import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../data/utils/open_email_link.dart';
import '../../domain/constants.dart';

class DrawerButton extends StatelessWidget {
  final IconData iconData;
  Function()? onPressed;
  String label;
  DrawerButton(
      {Key? key, required this.iconData, this.onPressed, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () { onPressed?.call(); },
      child: Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          border: new Border.all(color: Colors.black12),
          color: Colors.white,
        ),
        width: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(label, style: TextStyle(color: Colors.blue),)],
          ),
        ),
      ),
    );
  }
}
