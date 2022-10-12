import 'package:flutter/cupertino.dart';
import 'package:property_inspect/ui/pages/registration_form.dart';

import 'authenticated_page.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AuthenticatedPage(
      // This is where you give you custom widget it's data.
      body: Center(child: MyCustomForm()),
    );
  }
}
