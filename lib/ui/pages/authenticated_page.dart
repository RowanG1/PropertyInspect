import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/widgets/forbidden_page.dart';

import '../controllers/login_controller.dart';

class AuthenticatedPage extends StatelessWidget {
  final Widget body;

  const AuthenticatedPage({required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    return Scaffold(
      body: Obx(() =>
          loginController.getLoginState().value ? body : const ForbiddenPage()),
    );
  }
}
