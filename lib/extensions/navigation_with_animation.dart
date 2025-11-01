import 'package:flutter/material.dart';

/// ✅ Common navigation with fade + scale transition
Future<T?> navigateWithAnimation<T>({
  required BuildContext context,
  required Widget page,
  Duration duration = const Duration(milliseconds: 600),
  Duration reverseDuration = const Duration(milliseconds: 400),
  Curve curve = Curves.easeOutBack,
}) {
  return Navigator.push<T>(
    context,
    PageRouteBuilder(
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.96,
              end: 1.0,
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: page,
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}
