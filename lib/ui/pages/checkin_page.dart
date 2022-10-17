import 'package:flutter/cupertino.dart';
import 'package:property_inspect/ui/pages/resume_after_authenticated_page.dart';

class CheckinPage extends StatelessWidget {
  const CheckinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResumeAfterAuthenticatedPage(
        // This is where you give you custom widget it's data.
        body: const Center(child: Text('Checkin here.')));
  }
}
