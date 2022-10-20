import 'package:flutter/cupertino.dart';
import 'package:property_inspect/ui/pages/resume_after_authenticated_page.dart';

class ListingPage extends StatelessWidget {
  const ListingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResumeAfterAuthenticatedPage(
      // This is where you give you custom widget it's data.
      body: Center(child: Text('Hello, World')),
    );
  }
}
