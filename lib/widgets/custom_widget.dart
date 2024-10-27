import 'package:flutter/material.dart';

Widget customTile({required Widget child, required dynamic context}) {
  final tileWidth = ((MediaQuery.of(context).size.width - 48) / 2);

  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.grey[200],
    ),
    height: 120,
    width: tileWidth,
    child: child
  );
}
