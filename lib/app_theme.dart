import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static const Color lagoon = Color(0xFF0ea5a4);
  static const Color reef = Color(0xFF0284c7);
  static const Color forest = Color(0xFF16a34a);

  // Light theme colors
  static CupertinoThemeData cupertinoLight(Color primary) => CupertinoThemeData(
        primaryColor: primary,
        barBackgroundColor: const Color(0xCCFFFFFF),
        scaffoldBackgroundColor: const Color(0xFFF6F8F9),
        textTheme: const CupertinoTextThemeData(
          textStyle: TextStyle(color: Color(0xFF0F172A)),
        ),
      );

  // Dark theme colors
  static CupertinoThemeData cupertinoDark(Color primary) => const CupertinoThemeData.raw(
        Brightness.dark,
        primaryColor: Color(0xFF64D8D6),
        barBackgroundColor: Color(0x6610141F),
        scaffoldBackgroundColor: Color(0xFF0B1220),
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(color: Color(0xFFE2E8F0)),
        ),
      );
}

class Glass extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  const Glass({super.key, required this.child, this.padding=const EdgeInsets.all(16), this.radius=22});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: CupertinoTheme.of(context).barBackgroundColor?.withOpacity(0.55) ?? Colors.white54,
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: child,
        ),
      ),
    );
  }
}