import 'package:expenseek/controllers/entry_controller.dart';
import 'package:expenseek/widgets/login_widget.dart';
import 'package:expenseek/widgets/registration_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryScreen extends StatelessWidget {
  EntryScreen({super.key});
  final c = Get.put(EntryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16),
          child: c.isLogin.isNotEmpty
              ? loginWidget(
                  username: c.isLogin.value,
                  pinController: c.pinController,
                  action: c.loginAction)
              : registrationWidget(
                  usernameController: c.usernameController,
                  pinController: c.pinController,
                  action: c.registerAction),
        ),
      ),
    ));
  }
}
