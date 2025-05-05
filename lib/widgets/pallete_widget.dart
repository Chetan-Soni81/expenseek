import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

Widget palleteBox(Color c, RxString colorName) {
  return Container(
    color: c, // Set the background color
    height: 40, // Set the height of each button
    width: 40,
    child: Radio(
      fillColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if(c.value.toString() == colorName.value) {
          return Colors.white;
        } else {
          return c;
        }
      } ) ,
        value: c.value.toString(),
        groupValue: colorName.value,
        onChanged: (v) => colorName.value = v ?? Colors.white.value.toString()),
  ); // Set the width of each button
}
