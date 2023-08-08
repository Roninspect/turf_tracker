import 'package:flutter/material.dart';

Future<void> showAlertDialogWithConfirmation({
  required BuildContext context,
  required String message,
  required String ifyes,
  required String ifNo,
  required Function onLeavePressed,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black, // Dark background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Custom rounded corners
        ),

        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[400], // Grey button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              4.0), // Custom rounded corners
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Dismiss the dialog
                      },
                      child: Text(
                        ifNo,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red, // Red button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              4.0), // Custom rounded corners
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Dismiss the dialog
                        onLeavePressed(); // Call the onLeavePressed function passed as a parameter
                      },
                      child: Text(
                        ifyes,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
