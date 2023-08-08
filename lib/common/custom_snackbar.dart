import 'package:flutter/material.dart';

showSnackbar(
    {required BuildContext context,
    required String text,
    Color? color = Colors.red}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 4),
      backgroundColor: color,
      content: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
      )));
}
