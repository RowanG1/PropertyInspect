import 'package:flutter/cupertino.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';

class SignInContainer extends StatelessWidget {
  const SignInContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Arguments are');
    print(Get.arguments);

    return const SignInScreen(
      providerConfigs: [EmailProviderConfiguration()],
    );
  }
}
