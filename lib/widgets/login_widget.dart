import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:expenseek/helpers/theme_helper.dart';

Widget loginWidget({required String username,required TextEditingController pinController, required Function action }) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "ExpenSeek",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
      ),
      const SizedBox(
        height: 16,
      ),
      Text("Welcome, $username",style: const TextStyle(fontSize: 18),),
      const SizedBox(
        height: 16,
      ),
      Pinput(
        obscureText: true,
        length: 6,
        defaultPinTheme: ThemeHelper.defaultPinTheme,
        focusedPinTheme: ThemeHelper.focusedPinTheme,
        submittedPinTheme: ThemeHelper.submittedPinTheme,
        errorPinTheme: ThemeHelper.errorPinTheme,
        controller: pinController,
        onCompleted: (value) => action(),
      ),
      const SizedBox(
        height: 16,
      ),
    ],
  );
}
