import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palm_code_challenge/presentation/home/widgets/search_bar_delegate.dart';

void main() {
  group('SearchBarDelegate Tests', () {
    late TextEditingController testController;
    late bool onChangedCalled;
    late String onChangedValue;
    late bool onClearCalled;

    setUp(() {
      testController = TextEditingController();
      onChangedCalled = false;
      onChangedValue = '';
      onClearCalled = false;
    });

    tearDown(() {
      testController.dispose();
    });

    Widget createTestWidget(SearchBarDelegate delegate) {
      return MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [SliverPersistentHeader(pinned: true, delegate: delegate)],
          ),
        ),
      );
    }

    group('Constructor and properties', () {
      test('should initialize with required parameters', () {
        final delegate = SearchBarDelegate(
          searchController: testController,
          onChanged: (value) {},
          onClear: () {},
        );

        expect(delegate.searchController, equals(testController));
        expect(delegate.onChanged, isA<Function(String)>());
        expect(delegate.onClear, isA<VoidCallback>());
      });

      test('should have correct extent values', () {
        final delegate = SearchBarDelegate(
          searchController: testController,
          onChanged: (value) {},
          onClear: () {},
        );

        expect(delegate.minExtent, equals(80.0));
        expect(delegate.maxExtent, equals(80.0));
      });
    });

    group('Widget building', () {
      testWidgets('should build search bar widget', (
        WidgetTester tester,
      ) async {
        final delegate = SearchBarDelegate(
          searchController: testController,
          onChanged: (value) {
            onChangedCalled = true;
            onChangedValue = value;
          },
          onClear: () {
            onClearCalled = true;
          },
        );

        await tester.pumpWidget(createTestWidget(delegate));

        // Verify the search bar is rendered
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
        expect(find.text('Search books...'), findsOneWidget);
      });

      testWidgets('should show clear button when text is present', (
        WidgetTester tester,
      ) async {
        testController.text = 'test query';

        final delegate = SearchBarDelegate(
          searchController: testController,
          onChanged: (value) {
            onChangedCalled = true;
            onChangedValue = value;
          },
          onClear: () {
            onClearCalled = true;
          },
        );

        await tester.pumpWidget(createTestWidget(delegate));

        // Should show clear button when text is present
        expect(find.byIcon(Icons.clear), findsOneWidget);
      });

      testWidgets('should not show clear button when text is empty', (
        WidgetTester tester,
      ) async {
        testController.text = '';

        final delegate = SearchBarDelegate(
          searchController: testController,
          onChanged: (value) {
            onChangedCalled = true;
            onChangedValue = value;
          },
          onClear: () {
            onClearCalled = true;
          },
        );

        await tester.pumpWidget(createTestWidget(delegate));

        // Should not show clear button when text is empty
        expect(find.byIcon(Icons.clear), findsNothing);
      });

      testWidgets('should have correct styling', (WidgetTester tester) async {
        final delegate = SearchBarDelegate(
          searchController: testController,
          onChanged: (value) {},
          onClear: () {},
        );

        await tester.pumpWidget(createTestWidget(delegate));

        final textField = tester.widget<TextField>(find.byType(TextField));
        final decoration = textField.decoration!;

        expect(decoration.hintText, equals('Search books...'));
        expect(decoration.prefixIcon, isA<Icon>());
        expect(decoration.border, isA<OutlineInputBorder>());
        expect(decoration.filled, isTrue);
      });
    });

    group('User interactions', () {
      testWidgets('should call onChanged when text changes', (
        WidgetTester tester,
      ) async {
        final delegate = SearchBarDelegate(
          searchController: testController,
          onChanged: (value) {
            onChangedCalled = true;
            onChangedValue = value;
          },
          onClear: () {
            onClearCalled = true;
          },
        );

        await tester.pumpWidget(createTestWidget(delegate));

        // Type in the search field
        await tester.enterText(find.byType(TextField), 'flutter');
        await tester.pump();

        expect(onChangedCalled, isTrue);
        expect(onChangedValue, equals('flutter'));
      });

      testWidgets('should call onClear when clear button is tapped', (
        WidgetTester tester,
      ) async {
        testController.text = 'test query';

        final delegate = SearchBarDelegate(
          searchController: testController,
          onChanged: (value) {
            onChangedCalled = true;
            onChangedValue = value;
          },
          onClear: () {
            onClearCalled = true;
          },
        );

        await tester.pumpWidget(createTestWidget(delegate));

        // Tap the clear button
        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump();

        expect(onClearCalled, isTrue);
      });

      testWidgets('should update UI when controller text changes externally', (
        WidgetTester tester,
      ) async {
        final delegate = SearchBarDelegate(
          searchController: testController,
          onChanged: (value) {
            onChangedCalled = true;
            onChangedValue = value;
          },
          onClear: () {
            onClearCalled = true;
          },
        );

        await tester.pumpWidget(createTestWidget(delegate));

        // Initially no clear button
        expect(find.byIcon(Icons.clear), findsNothing);

        // Update controller externally
        testController.text = 'external update';
        await tester.pump();

        // Should now show clear button
        expect(find.byIcon(Icons.clear), findsOneWidget);
        expect(find.text('external update'), findsOneWidget);
      });
    });

    group('SliverPersistentHeaderDelegate implementation', () {
      testWidgets('should rebuild when shouldRebuild returns true', (
        WidgetTester tester,
      ) async {
        final delegate1 = SearchBarDelegate(
          searchController: testController,
          onChanged: (value) {},
          onClear: () {},
        );

        final delegate2 = SearchBarDelegate(
          searchController: testController,
          onChanged: (value) {},
          onClear: () {},
        );

        // shouldRebuild should always return true
        expect(delegate1.shouldRebuild(delegate2), isTrue);
      });

      testWidgets('should maintain consistent extent values', (
        WidgetTester tester,
      ) async {
        final delegate = SearchBarDelegate(
          searchController: testController,
          onChanged: (value) {},
          onClear: () {},
        );

        await tester.pumpWidget(createTestWidget(delegate));

        // Both min and max extent should be the same for a fixed-size header
        expect(delegate.minExtent, equals(delegate.maxExtent));
        expect(delegate.minExtent, equals(80.0));
      });
    });

    group('Theme integration', () {
      testWidgets('should use theme colors', (WidgetTester tester) async {
        final delegate = SearchBarDelegate(
          searchController: testController,
          onChanged: (value) {},
          onClear: () {},
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.red,
              colorScheme: const ColorScheme.light(surface: Colors.blue),
            ),
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(pinned: true, delegate: delegate),
                ],
              ),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(CustomScrollView),
                matching: find.byType(Container),
              )
              .first,
        );

        // Should use scaffold background color
        expect(container.color, equals(Colors.red));
      });
    });
  });
}
