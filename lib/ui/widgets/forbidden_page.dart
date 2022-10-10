import 'package:flutter/cupertino.dart';

class ForbiddenPage extends StatelessWidget {
  const ForbiddenPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Center(
        child:
            Text("You are not authorized to view this page. Please log in."));
  }
}
