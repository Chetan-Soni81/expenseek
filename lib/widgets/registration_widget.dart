import 'package:expenseek/helpers/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

Widget registrationWidget(
    {required TextEditingController usernameController,
    required TextEditingController pinController,
    required Function action}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "ExpenSeek",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
      ),
      const SizedBox(
        height: 16,
      ),
      TextField(
        decoration: const InputDecoration(
            fillColor: Color(0xFFeceef6),
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide.none),
            labelText: "Username",
            labelStyle: TextStyle(color: Colors.black)),
        controller: usernameController,
      ),
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
      ),
      const SizedBox(
        height: 16,
      ),
      SizedBox(
        width: double.infinity, // Makes the button full width
        child: ElevatedButton(
          // Button action
          onPressed: () => action(),
          child: const Text('Register'),
        ),
      ),
    ],
  );
}
