import 'package:flutter/material.dart';
import 'package:logan_misses_you/ui/shared/constants.dart';

class AppIcon extends StatelessWidget {
  static const double size = 32.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          width: size,
          height: size,
          child: Image.asset(appIconImagePath),
        ),
      ),
    );
  }
}
