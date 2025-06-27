import 'package:flutter_test/flutter_test.dart';
import 'package:palm_code_challenge/common/utils/image_utils.dart';

void main() {
  group('ImageUtils Tests', () {
    group('getSafeImageUrl', () {
      test('should return empty string for null URL', () {
        expect(ImageUtils.getSafeImageUrl(null), equals(''));
      });

      test('should return empty string for empty URL', () {
        expect(ImageUtils.getSafeImageUrl(''), equals(''));
      });

      test('should return original URL for safe URLs', () {
        const safeUrl = 'https://example.com/image.jpg';
        expect(ImageUtils.getSafeImageUrl(safeUrl), equals(safeUrl));
      });

      test('should replace problematic via.placeholder.com URLs', () {
        const problematicUrl = 'https://via.placeholder.com/150/200';
        final result = ImageUtils.getSafeImageUrl(problematicUrl);
        expect(result, isNot(equals(problematicUrl)));
        expect(result, contains('picsum.photos'));
      });

      test('should replace problematic placeholder.com URLs', () {
        const problematicUrl = 'https://placeholder.com/150x200';
        final result = ImageUtils.getSafeImageUrl(problematicUrl);
        expect(result, isNot(equals(problematicUrl)));
        expect(result, contains('picsum.photos'));
      });

      test('should replace problematic dummyimage.com URLs', () {
        const problematicUrl = 'https://dummyimage.com/150x200';
        final result = ImageUtils.getSafeImageUrl(problematicUrl);
        expect(result, isNot(equals(problematicUrl)));
        expect(result, contains('picsum.photos'));
      });

      test('should use bookId when provided for problematic URLs', () {
        const problematicUrl = 'https://via.placeholder.com/150/200';
        const bookId = 123;
        final result = ImageUtils.getSafeImageUrl(
          problematicUrl,
          bookId: bookId,
        );
        expect(result, contains('random=$bookId'));
      });

      test('should be case insensitive for problematic URLs', () {
        const problematicUrl = 'https://VIA.PLACEHOLDER.COM/150/200';
        final result = ImageUtils.getSafeImageUrl(problematicUrl);
        expect(result, isNot(equals(problematicUrl)));
        expect(result, contains('picsum.photos'));
      });

      test('should handle URLs containing problematic hosts in path', () {
        const problematicUrl =
            'https://cdn.example.com/via.placeholder.com/image.jpg';
        final result = ImageUtils.getSafeImageUrl(problematicUrl);
        expect(result, isNot(equals(problematicUrl)));
        expect(result, contains('picsum.photos'));
      });
    });

    group('getOfflinePlaceholder', () {
      test('should return empty string for offline placeholder', () {
        expect(ImageUtils.getOfflinePlaceholder(), equals(''));
      });
    });

    group('hasInternetConnection', () {
      test('should return a boolean value', () async {
        final result = await ImageUtils.hasInternetConnection();
        expect(result, isA<bool>());
      });
    });
  });
}
