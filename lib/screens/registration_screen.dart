import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("ExpenSeek", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),),
            const SizedBox(height: 16,),
            const TextField(
              decoration: InputDecoration(
                fillColor: Color(0xFFeceef6),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none
                ),
                labelText: "Username",
                labelStyle: TextStyle(color: Colors.black)
              ),
            ),
            const SizedBox(height: 16,),
            const Pinput(
              obscureText: true,
              length: 6,
            ),
            const SizedBox(height: 16,),
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
        ),
      ),
    ));
  }
}
