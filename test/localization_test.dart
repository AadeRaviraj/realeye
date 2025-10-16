import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:realeyes/generated/app_localizations.dart';
import 'package:realeyes/main.dart'; // Import your main app file

void main() {
  testWidgets('displays Hindi text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('hi'),
        home: Builder(
          builder: (context) => Scaffold(
            body: Text(AppLocalizations.of(context).hello),
          ),
        ),
      ),
    );

    expect(find.text('नमस्ते'), findsOneWidget);
  });
}