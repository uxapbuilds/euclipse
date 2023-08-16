import 'package:flutter/material.dart';

class Navigate {
  void navigate(toPage, context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => toPage,
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  void navigateAndRemoveUntil(toPage, context) {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => toPage,
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 250),
        ),
        ((route) => false));
  }

  void popView(BuildContext context) {
    Navigator.pop(context);
  }
}
