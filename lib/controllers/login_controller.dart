import 'package:expenseek/helpers/sql_helper.dart';
import 'package:expenseek/models/profile_model.dart';
import 'package:expenseek/screens/home_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  Rx<ProfileModel?> profile = null.obs;
  late TextEditingController usernameController, passwordController;

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getProfile();
  }

  getProfile() async {
    profile.value = await SQLHelper.getProfile();
  }

  loginUser() async {
    bool data = await SQLHelper.loginProfile(
        usernameController.text, passwordController.text);

    if (data) {
      Get.off(() => const HomeScreen());
    } else {}
  }

  registerUser() async {}
}
