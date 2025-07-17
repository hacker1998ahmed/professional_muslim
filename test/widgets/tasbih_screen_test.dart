import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:professional_muslim/screens/tasbih_screen.dart';
import 'package:professional_muslim/providers/azkar_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('TasbihScreen Widget Tests', () {
    late AzkarProvider azkarProvider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      azkarProvider = AzkarProvider();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<AzkarProvider>.value(
          value: azkarProvider,
          child: const TasbihScreen(),
        ),
      );
    }

    testWidgets('should display tasbih screen with initial count', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check if the screen title is displayed
      expect(find.text('السبحة الإلكترونية'), findsOneWidget);

      // Check if the initial count is 0
      expect(find.text('0'), findsOneWidget);

      // Check if the tap instruction is displayed
      expect(find.text('انقر للتسبيح'), findsOneWidget);

      // Check if the refresh button is present
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Check if the touch button is present
      expect(find.byIcon(Icons.touch_app), findsOneWidget);
    });

    testWidgets('should increment count when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the touchable area and tap it
      final touchArea = find.byType(GestureDetector);
      expect(touchArea, findsOneWidget);

      await tester.tap(touchArea);
      await tester.pumpAndSettle();

      // Check if count increased to 1
      expect(find.text('1'), findsOneWidget);

      // Tap again
      await tester.tap(touchArea);
      await tester.pumpAndSettle();

      // Check if count increased to 2
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should reset count when refresh button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // First increment the count
      final touchArea = find.byType(GestureDetector);
      await tester.tap(touchArea);
      await tester.tap(touchArea);
      await tester.pumpAndSettle();

      // Verify count is 2
      expect(find.text('2'), findsOneWidget);

      // Tap refresh button
      final refreshButton = find.byIcon(Icons.refresh);
      await tester.tap(refreshButton);
      await tester.pumpAndSettle();

      // Check if count reset to 0
      expect(find.text('0'), findsOneWidget);

      // Check if snackbar is shown
      expect(find.text('تم إعادة تعيين العداد'), findsOneWidget);
    });

    testWidgets('should display correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check if the main container has correct styling
      final containers = find.byType(Container);
      expect(containers, findsWidgets);

      // Check if cards are present for styling
      final cards = find.byType(Card);
      expect(cards, findsNothing); // TasbihScreen doesn't use cards directly

      // Check if the circular design is present
      final gestureDetector = find.byType(GestureDetector);
      expect(gestureDetector, findsOneWidget);
    });

    testWidgets('should handle multiple rapid taps', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final touchArea = find.byType(GestureDetector);

      // Tap multiple times rapidly
      for (int i = 0; i < 10; i++) {
        await tester.tap(touchArea);
      }
      await tester.pumpAndSettle();

      // Check if count is 10
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('should maintain count across widget rebuilds', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Increment count
      final touchArea = find.byType(GestureDetector);
      await tester.tap(touchArea);
      await tester.tap(touchArea);
      await tester.tap(touchArea);
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);

      // Trigger a rebuild by pumping the widget again
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Count should still be 3
      expect(find.text('3'), findsOneWidget);
    });
  });
}
