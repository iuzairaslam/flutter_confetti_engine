import 'package:flutter/material.dart';
import 'package:flutter_confetti_engine/flutter_confetti_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ConfettiEngine.celebrate is safe without Overlay',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            ConfettiEngine.celebrate(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(ConfettiWidget), findsNothing);
  });

  testWidgets('ConfettiWidget builds inside MaterialApp',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox.expand(
            child: ConfettiWidget(preset: Preset.nova, autoPlay: false),
          ),
        ),
      ),
    );
    expect(find.byType(ConfettiWidget), findsOneWidget);
  });

  testWidgets('ConfettiEngine.celebrate inserts overlay with ConfettiWidget',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => ConfettiEngine.celebrate(context),
                child: const Text('go'),
              ),
            ),
          ),
        ),
      ),
    );

    ConfettiEngine.celebrate(tester.element(find.byType(ElevatedButton)));
    await tester.pump();

    expect(find.byType(ConfettiWidget), findsOneWidget);
    expect(find.byType(IgnorePointer), findsWidgets);
  });

  testWidgets('ConfettiEngine.dismiss removes overlay',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () =>
                  ConfettiEngine.celebrate(context, preset: Preset.flare),
              child: const Text('go'),
            ),
          ),
        ),
      ),
    );

    ConfettiEngine.celebrate(tester.element(find.byType(ElevatedButton)));
    await tester.pump();
    expect(find.byType(ConfettiWidget), findsOneWidget);

    ConfettiEngine.dismiss();
    await tester.pump();
    expect(find.byType(ConfettiWidget), findsNothing);
  });

  testWidgets('ConfettiWidget works with unbounded height from scroll view',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ConfettiWidget(
              preset: Preset.nova,
              autoPlay: false,
            ),
          ),
        ),
      ),
    );
    expect(find.byType(ConfettiWidget), findsOneWidget);
  });

  testWidgets('second celebrate replaces previous overlay',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => const Scaffold(body: SizedBox.shrink()),
        ),
      ),
    );

    final ctx = tester.element(find.byType(Scaffold));
    ConfettiEngine.celebrate(ctx, preset: Preset.nova);
    await tester.pump();
    expect(find.byType(ConfettiWidget), findsOneWidget);

    ConfettiEngine.celebrate(ctx, preset: Preset.cascade);
    await tester.pump();
    expect(find.byType(ConfettiWidget), findsOneWidget);
  });
}
