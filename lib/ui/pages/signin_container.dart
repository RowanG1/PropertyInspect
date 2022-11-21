import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../data/types/env.dart';
import '../../domain/constants.dart';

class SignInContainer extends StatelessWidget {
  const SignInContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Env env = Get.find();
    return (env.env != Constants.unitTestEnv) ? const SignInScreen() : const Text('Sign in page');
  }
}
