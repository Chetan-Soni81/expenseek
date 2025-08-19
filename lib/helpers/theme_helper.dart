import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class ThemeHelper {
  static final defaultPinTheme = PinTheme(
    width: 60,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 24,
      color: Colors.deepPurple,
      fontWeight: FontWeight.bold,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: ThemeColors.baseColor.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(6),
    ),
  );

  static final focusedPinTheme = defaultPinTheme.copyWith(
    decoration: BoxDecoration(
      border: Border.all(color: ThemeColors.baseColor.withOpacity(.8), width: 2),
      borderRadius: BorderRadius.circular(6),
      color: ThemeColors.lightPurple.withOpacity(0.3),
    ),
  );

  static final submittedPinTheme = defaultPinTheme.copyWith(
    decoration: BoxDecoration(
      color: ThemeColors.baseColor.withOpacity(0.1),
      border: Border.all(color: ThemeColors.darkPurple),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  static final errorPinTheme = defaultPinTheme.copyWith(
    decoration: BoxDecoration(
      color: Colors.red[50],
      border: Border.all(color: Colors.red),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

class ThemeColors {
  static const baseColor = Colors.deepPurple;
  static final lightPurple = Colors.deepPurple[100]!;
  static final darkPurple = Colors.deepPurple[500]!;
}

class PalletHelper{
  static final colors = [
    Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.yellow,
  Colors.brown,
  Colors.cyan,
  Colors.teal,
  Colors.indigo,
  Colors.pink,
  Colors.lime,
  Colors.deepPurple,
  Colors.deepOrange,
  Colors.amber,
  Colors.lightGreen,
  Colors.blueGrey,
  Colors.greenAccent,
  Colors.blueAccent,
  Colors.redAccent,
  Colors.orangeAccent,
  Colors.purpleAccent,
  Colors.cyanAccent,
  Colors.tealAccent,
  Colors.pinkAccent,
  Colors.limeAccent,
  ];
}