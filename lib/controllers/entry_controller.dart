import 'package:expenseek/helpers/db_helper.dart';
import 'package:expenseek/models/user_model.dart';
import 'package:expenseek/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryController extends GetxController {
  RxString isLogin = "".obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    checkUserExists();
  }

  checkUserExists() async {
    isLogin.value = await DbHelper.userExists();
  }

  registerAction() async {
    var user =
        UserModel(username: usernameController.text, pin: pinController.text);

    int Uid = await DbHelper.registerUser(user);

    print(Uid);
  }

  loginAction() async {
    var user =
        UserModel(username: isLogin.value, pin: pinController.text);

    String? uId = await DbHelper.loginUser(user);

    if (uId != null && uId.isNotEmpty) {
      Get.off(() => HomeScreen(), arguments: uId);
      return;
    }

    Get.showSnackbar(const GetSnackBar(
      title: "Login Failed!!",
      message: "Invalid Pincode entered.",
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
      animationDuration: Duration(seconds: 1),
    ));
  }
}
