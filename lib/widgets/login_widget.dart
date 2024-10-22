import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

Widget loginWidget() {
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
      const Text("Welcome, Chetan Soni"),
      const SizedBox(
        height: 16,
      ),
      const Pinput(
        obscureText: true,
        length: 6,
      ),
      const SizedBox(
        height: 16,
      ),
      SizedBox(
        width: double.infinity, // Makes the button full width
        child: ElevatedButton(
          onPressed: () {
            // Button action
          },
          child: const Text('Register'),
        ),
      ),
    ],
  );
}
