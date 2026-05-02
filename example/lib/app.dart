import 'package:flutter/material.dart';

import 'demo/demo_home.dart';
import 'demo/demo_prefs.dart';
import 'demo/demo_theme.dart';

/// Root Material app for the package example (light theme · coral accent).
class ConfettiExampleApp extends StatefulWidget {
  const ConfettiExampleApp({super.key});

  @override
  State<ConfettiExampleApp> createState() => _ConfettiExampleAppState();
}

class _ConfettiExampleAppState extends State<ConfettiExampleApp> {
  bool _useTickPhysics = false;

  @override
  Widget build(BuildContext context) {
    return DemoPrefsScope(
      useTickPhysics: _useTickPhysics,
      onTickPhysicsChanged: (v) => setState(() => _useTickPhysics = v),
      child: MaterialApp(
        title: 'flutter_confetti_engine Demo',
        debugShowCheckedModeBanner: false,
        theme: buildDemoTheme(),
        builder: (context, child) {
          return DefaultTextStyle(
            style: const TextStyle(decoration: TextDecoration.none),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: const DemoHome(),
      ),
    );
  }
}
