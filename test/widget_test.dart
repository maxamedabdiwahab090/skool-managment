import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:myapp/main.dart';
import 'package:myapp/src/utils/theme_provider.dart';
import 'package:myapp/src/views/splash_screen.dart';

void main() {
  testWidgets('SplashScreen navigates to LoginScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
      ),
    );

    // Verify that SplashScreen is shown initially.
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('School Management System'), findsOneWidget);

    // Wait for the splash screen to finish and navigate to the login screen.
    // The splash screen waits for 3 seconds.
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Verify that we have navigated to the LoginScreen.
    expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);
    expect(find.byType(SplashScreen), findsNothing);
  });
}
