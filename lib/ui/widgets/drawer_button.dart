import 'package:flutter/material.dart';

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
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          border: Border.all(color: Colors.black12),
          color: Colors.white,
        ),
        width: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,
            children: [Text(label, style: const TextStyle(color: Colors.blue, fontSize: 11, fontFamily: "Arial"),)],
          ),
        ),
      ),
    );
  }
}
