import 'package:flutter/material.dart';

/// Full-screen animated gradient backdrop that smoothly transitions colors
/// whenever the weather condition (and thus [colors]) changes.
class WeatherBackground extends StatelessWidget {
  final List<Color> colors;
  final Widget child;

  const WeatherBackground({super.key, required this.colors, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
