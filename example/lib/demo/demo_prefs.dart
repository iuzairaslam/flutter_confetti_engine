import 'package:flutter/material.dart';

/// Tick-physics toggle shared across the catalog and pushed detail routes.
class DemoPrefsScope extends InheritedWidget {
  const DemoPrefsScope({
    super.key,
    required this.useTickPhysics,
    required this.onTickPhysicsChanged,
    required super.child,
  });

  final bool useTickPhysics;
  final ValueChanged<bool> onTickPhysicsChanged;

  static DemoPrefsScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DemoPrefsScope>();
  }

  static DemoPrefsScope of(BuildContext context) {
    final s = maybeOf(context);
    assert(s != null, 'DemoPrefsScope not found');
    return s!;
  }

  @override
  bool updateShouldNotify(covariant DemoPrefsScope oldWidget) {
    return oldWidget.useTickPhysics != useTickPhysics;
  }
}
