import 'package:flutter/material.dart';

class CustomAlert {
  /// Displays a reusable custom alert dialog using Flutter's built-in widgets.
  static Future<void> showAlert(
      BuildContext context, {
        required String message,
        String? title,
        String btnFirst = 'OK',
        String? btnSecond,
        VoidCallback? onFirstPressed,
        VoidCallback? onSecondPressed,
        bool barrierDismissible = false,
      }) async {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: title != null && title.isNotEmpty
              ? Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )
              : null,
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            if (btnSecond != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onSecondPressed != null) onSecondPressed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                child: Text(btnSecond),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onFirstPressed != null) onFirstPressed();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              child: Text(btnFirst),
            ),
          ],
        );
      },
    );
  }
}
