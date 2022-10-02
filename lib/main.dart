import 'package:flutter/material.dart';
import 'package:newpro/Screen/Home.dart';
import 'package:newpro/Widget/Start_Screen.dart';
import 'package:newpro/example.dart';
import 'package:newpro/exmple2.dart';

import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:newpro/data/List.dart';
import 'package:newpro/data/db_config.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
//bool light=true;
String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isMaterial =true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child:
          MyStart(
          savedThemeMode: widget.savedThemeMode,
          onChanged: () => setState(() => isMaterial = false))
    );
  }
}