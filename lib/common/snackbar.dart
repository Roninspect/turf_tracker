import 'package:flutter/material.dart';

class ErrorSnackbar {
  void showsnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 0),
      content: Text(text),
      duration: const Duration(seconds: 1),
    ));
  }
}
