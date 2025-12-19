import 'package:expenseek/di/service_locator.dart';
import 'package:expenseek/exceptions/app_exceptions.dart';
import 'package:expenseek/models/user_model.dart';
import 'package:expenseek/repositories/user_repository.dart';
import 'package:expenseek/screens/home_screen.dart';
import 'package:expenseek/utils/logger.dart';
import 'package:expenseek/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryController extends GetxController {
  RxString isLogin = "".obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  late UserRepository userRepository;
  RxBool isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    userRepository = getIt<UserRepository>();
    checkUserExists();
  }

  checkUserExists() async {
    try {
      isLoading.value = true;
    isLogin.value = await userRepository.userExists();
    } catch (e) {
      AppLogger.error('Failed to check user existence', e);
      _showError('Failed to check user', e);
    } finally {
      isLoading.value = false;
    }
  }

  registerAction() async {
    try {
      final username = Validation.validateUsername(usernameController.text);
      final pin = Validation.validatePin(pinController.text);

      isLoading.value = true;
      var user = UserModel(username: username, pin: pin);

    int uId = await userRepository.registerUser(user);

    if(uId > 0) {
      Get.off(() => HomeScreen(), arguments: uId.toString());
      return;
      } else {
        throw DatabaseException('Failed to register user');
      }
    } catch (e) {
      _showError('Failed to register', e);
    } finally {
      isLoading.value = false;
    }
  }

  loginAction() async {
    try {
      final pin = Validation.validatePin(pinController.text);

      if (isLogin.value.isEmpty) {
        throw ValidationException('Username not found');
      }

      isLoading.value = true;
      var user = UserModel(username: isLogin.value, pin: pin);

    String? uId = await userRepository.loginUser(user);

    if (uId != null && uId.isNotEmpty) {
      Get.off(() => HomeScreen(), arguments: uId);
      return;
    }

      throw ValidationException('Invalid PIN entered');
    } catch (e) {
      _showError('Login failed', e);
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String message, dynamic error) {
    AppLogger.error(message, error);
    Get.showSnackbar(GetSnackBar(
      title: "Error",
      message: error is AppException ? error.message : message,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ));
  }
}
