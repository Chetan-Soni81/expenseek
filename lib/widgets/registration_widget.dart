import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

Widget registrationWidget() {
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
      const TextField(
        decoration: InputDecoration(
            fillColor: Color(0xFFeceef6),
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide.none),
            labelText: "Username",
            labelStyle: TextStyle(color: Colors.black)),
      ),
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
