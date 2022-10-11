import 'package:flutter/cupertino.dart';

class ForbiddenPage extends StatelessWidget {
  const ForbiddenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child:
            Text("You are not authorized to view this page. Please log in."));
  }
}
