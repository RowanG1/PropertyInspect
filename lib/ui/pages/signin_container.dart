import 'package:flutter/cupertino.dart';
import 'package:flutterfire_ui/auth.dart';

class SignInContainer extends StatelessWidget {
  SignInContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SignInScreen(
      providerConfigs: [EmailProviderConfiguration()],
    );
  }
}
