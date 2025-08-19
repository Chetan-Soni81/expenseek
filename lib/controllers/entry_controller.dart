import 'package:expenseek/models/user_model.dart';
import 'package:expenseek/repositories/user_repository.dart';
import 'package:expenseek/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryController extends GetxController {
  RxString isLogin = "".obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  late UserRepository userRepository;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    userRepository = UserRepository();
    checkUserExists();
  }

  checkUserExists() async {
    isLogin.value = await userRepository.userExists();
  }

  registerAction() async {
    var user =
        UserModel(username: usernameController.text, pin: pinController.text);

    int uId = await userRepository.registerUser(user);

    if(uId > 0) {
      Get.off(() => HomeScreen(), arguments: uId.toString());
      return;
    }
  }

  loginAction() async {
    var user =
        UserModel(username: isLogin.value, pin: pinController.text);

    String? uId = await userRepository.loginUser(user);

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
