import 'package:flutter/cupertino.dart';
import 'package:property_inspect/ui/pages/authenticated_page.dart';

class ListingPage extends StatelessWidget {
  const ListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthenticatedPage(
      // This is where you give you custom widget it's data.
      body: Center(child: Text('Hello, World')),
    );
  }
}
