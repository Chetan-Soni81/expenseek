import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

Widget loginWidget({required String username,required TextEditingController pinController, required Function action }) {
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
      Text("Welcome, $username"),
      const SizedBox(
        height: 16,
      ),
      Pinput(
        obscureText: true,
        length: 6,
        controller: pinController,
        onCompleted: (value) => action(),
      ),
      const SizedBox(
        height: 16,
      ),
      // SizedBox(
      //   width: double.infinity, // Makes the button full width
      //   child: ElevatedButton(
      //       // Button action
      //     onPressed: () => action(),
      //     child: const Text('Login'),
      //   ),
      // ),
    ],
  );
}
