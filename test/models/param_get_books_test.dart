import 'package:flutter_test/flutter_test.dart';
import 'package:palm_code_challenge/data/models/params/param_get_books.dart';

void main() {
  group('ParamGetBooks Tests', () {
    group('Constructor', () {
      test('should create with default values', () {
        const param = ParamGetBooks();

        expect(param.page, equals(1));
        expect(param.search, isNull);
      });

      test('should create with provided values', () {
        const param = ParamGetBooks(page: 5, search: 'flutter');

        expect(param.page, equals(5));
        expect(param.search, equals('flutter'));
      });

      test('should create with page only', () {
        const param = ParamGetBooks(page: 3);

        expect(param.page, equals(3));
        expect(param.search, isNull);
      });

      test('should create with search only', () {
        const param = ParamGetBooks(search: 'dart');

        expect(param.page, equals(1)); // default value
        expect(param.search, equals('dart'));
      });
    });

    group('copyWith method', () {
      test('should create copy with updated page', () {
        const original = ParamGetBooks(page: 1, search: 'original');
        final updated = original.copyWith(page: 2);

        expect(updated.page, equals(2));
        expect(updated.search, equals('original')); // unchanged
      });

      test('should create copy with updated search', () {
        const original = ParamGetBooks(page: 5, search: 'original');
        final updated = original.copyWith(search: 'updated');

        expect(updated.page, equals(5)); // unchanged
        expect(updated.search, equals('updated'));
      });

      test('should create copy with both values updated', () {
        const original = ParamGetBooks(page: 1, search: 'original');
        final updated = original.copyWith(page: 3, search: 'updated');

        expect(updated.page, equals(3));
        expect(updated.search, equals('updated'));
      });

      test(
        'should create copy with no changes when no parameters provided',
        () {
          const original = ParamGetBooks(page: 2, search: 'test');
          final copy = original.copyWith();

          expect(copy.page, equals(original.page));
          expect(copy.search, equals(original.search));
        },
      );

      test('should handle null search value in copyWith', () {
        const original = ParamGetBooks(page: 1, search: 'test');
        final updated = original.copyWith(search: null);

        expect(updated.page, equals(1)); // unchanged
        expect(updated.search, isNull);
      });

      test('should preserve null search when copying', () {
        const original = ParamGetBooks(page: 1, search: null);
        final updated = original.copyWith(page: 2);

        expect(updated.page, equals(2));
        expect(updated.search, isNull);
      });
    });

    group('Equality', () {
      test('should be equal for same values', () {
        const param1 = ParamGetBooks(page: 2, search: 'flutter');
        const param2 = ParamGetBooks(page: 2, search: 'flutter');

        expect(param1, equals(param2));
      });

      test('should not be equal for different page values', () {
        const param1 = ParamGetBooks(page: 1, search: 'flutter');
        const param2 = ParamGetBooks(page: 2, search: 'flutter');

        expect(param1, isNot(equals(param2)));
      });

      test('should not be equal for different search values', () {
        const param1 = ParamGetBooks(page: 1, search: 'flutter');
        const param2 = ParamGetBooks(page: 1, search: 'dart');

        expect(param1, isNot(equals(param2)));
      });

      test(
        'should not be equal when one has null search and other has value',
        () {
          const param1 = ParamGetBooks(page: 1, search: null);
          const param2 = ParamGetBooks(page: 1, search: 'flutter');

          expect(param1, isNot(equals(param2)));
        },
      );

      test('should be equal when both have null search', () {
        const param1 = ParamGetBooks(page: 1, search: null);
        const param2 = ParamGetBooks(page: 1, search: null);

        expect(param1, equals(param2));
      });

      test('should be equal with default constructor values', () {
        const param1 = ParamGetBooks();
        const param2 = ParamGetBooks();

        expect(param1, equals(param2));
      });
    });

    group('Props', () {
      test('should include page and search in props', () {
        const param = ParamGetBooks(page: 3, search: 'test');

        expect(param.props, contains(3));
        expect(param.props, contains('test'));
        expect(param.props.length, equals(2));
      });

      test('should include null search in props', () {
        const param = ParamGetBooks(page: 1, search: null);

        expect(param.props, contains(1));
        expect(param.props, contains(null));
        expect(param.props.length, equals(2));
      });

      test('should have consistent props for equal objects', () {
        const param1 = ParamGetBooks(page: 2, search: 'flutter');
        const param2 = ParamGetBooks(page: 2, search: 'flutter');

        expect(param1.props, equals(param2.props));
      });
    });

    group('Edge cases', () {
      test('should handle zero page value', () {
        const param = ParamGetBooks(page: 0);

        expect(param.page, equals(0));
        expect(param.search, isNull);
      });

      test('should handle negative page value', () {
        const param = ParamGetBooks(page: -1);

        expect(param.page, equals(-1));
        expect(param.search, isNull);
      });

      test('should handle large page values', () {
        const param = ParamGetBooks(page: 999999);

        expect(param.page, equals(999999));
        expect(param.search, isNull);
      });

      test('should handle empty string search', () {
        const param = ParamGetBooks(search: '');

        expect(param.page, equals(1)); // default
        expect(param.search, equals(''));
      });

      test('should handle whitespace search', () {
        const param = ParamGetBooks(search: '   ');

        expect(param.page, equals(1)); // default
        expect(param.search, equals('   '));
      });

      test('should handle special characters in search', () {
        const param = ParamGetBooks(search: '!@#\$%^&*()_+');

        expect(param.page, equals(1)); // default
        expect(param.search, equals('!@#\$%^&*()_+'));
      });

      test('should handle unicode characters in search', () {
        const param = ParamGetBooks(search: '🚀 Flutter 📱');

        expect(param.page, equals(1)); // default
        expect(param.search, equals('🚀 Flutter 📱'));
      });
    });

    group('Immutability', () {
      test('original object should remain unchanged after copyWith', () {
        const original = ParamGetBooks(page: 1, search: 'original');
        final copy = original.copyWith(page: 2, search: 'modified');

        // Original should be unchanged
        expect(original.page, equals(1));
        expect(original.search, equals('original'));

        // Copy should have new values
        expect(copy.page, equals(2));
        expect(copy.search, equals('modified'));
      });

      test('should be const constructible', () {
        // This test verifies that the class can be used as a const constructor
        const param1 = ParamGetBooks(page: 1, search: 'test');
        const param2 = ParamGetBooks(page: 1, search: 'test');

        expect(identical(param1, param2), isTrue);
      });
    });
  });
}
