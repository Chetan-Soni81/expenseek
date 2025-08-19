import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../helpers/theme_helper.dart';

Widget palleteBox(Color c, RxString colorName) {
  return Container(
    color: c, // Set the background color
    height: 40, // Set the height of each button
    width: 40,
    child: Radio(
        fillColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (c.value.toString() == colorName.value) {
            return Colors.white;
          } else {
            return c;
          }
        }),
        value: c.value.toString(),
        groupValue: colorName.value,
        onChanged: (v) => colorName.value = v ?? Colors.white.value.toString()),
  ); // Set the width of each button
}

Widget palleteWidget({required RxString colorName}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          palleteBox(PalletHelper.colors[0], colorName),
          palleteBox(PalletHelper.colors[2], colorName),
          palleteBox(PalletHelper.colors[1], colorName),
          palleteBox(PalletHelper.colors[3], colorName),
          palleteBox(PalletHelper.colors[4], colorName),
        ],
      ),
      const SizedBox(
        height: 12,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          palleteBox(PalletHelper.colors[5], colorName),
          palleteBox(PalletHelper.colors[6], colorName),
          palleteBox(PalletHelper.colors[7], colorName),
          palleteBox(PalletHelper.colors[8], colorName),
          palleteBox(PalletHelper.colors[9], colorName),
        ],
      ),
      const SizedBox(
        height: 12,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          palleteBox(PalletHelper.colors[10], colorName),
          palleteBox(PalletHelper.colors[11], colorName),
          palleteBox(PalletHelper.colors[12], colorName),
          palleteBox(PalletHelper.colors[13], colorName),
          palleteBox(PalletHelper.colors[14], colorName),
        ],
      ),
      const SizedBox(
        height: 12,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          palleteBox(PalletHelper.colors[15], colorName),
          palleteBox(PalletHelper.colors[16], colorName),
          palleteBox(PalletHelper.colors[17], colorName),
          palleteBox(PalletHelper.colors[18], colorName),
          palleteBox(PalletHelper.colors[19], colorName),
        ],
      ),
    ],
  );
}
