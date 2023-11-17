import 'package:flutter/material.dart';
import 'package:cruise_app/home.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
      colorSchemeSeed: const Color(0x002f5da8),
      useMaterial3: true),
  home: const Menu(),
));
