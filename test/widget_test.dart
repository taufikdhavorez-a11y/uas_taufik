import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that the splash screen shows 'TTS'.
    expect(find.text('TTS'), findsOneWidget);

    // Wait for the splash screen delay timer to fire and navigation transition to complete
    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 800));
  });
}
