import 'package:flutter_test/flutter_test.dart';
import 'package:palm_code_challenge/data/models/author.dart';
import 'package:palm_code_challenge/data/models/book.dart';

void main() {
  group('Book Model Tests', () {
    late Book testBook;
    late List<Author> testAuthors;

    setUp(() {
      testAuthors = [
        const Author(name: 'John Doe', birthYear: 1980, deathYear: null),
        const Author(name: 'Jane Smith', birthYear: 1975, deathYear: 2020),
      ];

      testBook = Book(
        id: 1,
        title: 'Test Book',
        authors: testAuthors,
        subjects: ['Fiction', 'Adventure', 'Mystery'],
        bookshelves: ['Popular Books', 'New Releases'],
        languages: ['en'],
        copyright: false,
        mediaType: 'Text',
        formats: {
          'image/jpeg': 'https://example.com/cover.jpg',
          'text/html': 'https://example.com/book.html',
          'text/plain': 'https://example.com/book.txt',
        },
        downloadCount: 1500,
      );
    });

    group('imageUrl getter', () {
      test('should return image/jpeg format when available', () {
        final book = testBook.copyWith(
          formats: {
            'image/jpeg': 'https://example.com/cover.jpg',
            'text/html': 'https://example.com/book.html',
          },
        );

        expect(book.imageUrl, equals('https://example.com/cover.jpg'));
      });

      test('should return text/html format when image/jpeg not available', () {
        final book = testBook.copyWith(
          formats: {
            'text/html': 'https://example.com/book.html',
            'text/plain': 'https://example.com/book.txt',
          },
        );

        expect(book.imageUrl, equals('https://example.com/book.html'));
      });

      test('should handle problematic URLs through ImageUtils', () {
        final book = testBook.copyWith(
          formats: {'image/jpeg': 'https://via.placeholder.com/150/200'},
        );

        final imageUrl = book.imageUrl;
        expect(imageUrl, isNot(equals('https://via.placeholder.com/150/200')));
        expect(imageUrl, contains('picsum.photos'));
      });

      test('should return null-safe value when formats are empty', () {
        final book = testBook.copyWith(formats: {});

        expect(book.imageUrl, isNotNull);
      });
    });

    group('safeImageUrl getter', () {
      test('should return URL when imageUrl is valid', () {
        final book = testBook.copyWith(
          formats: {'image/jpeg': 'https://example.com/cover.jpg'},
        );

        expect(book.safeImageUrl, equals('https://example.com/cover.jpg'));
      });

      test('should return empty string when imageUrl is empty', () {
        final book = testBook.copyWith(formats: {});

        // Since ImageUtils.getSafeImageUrl returns empty for null/empty input
        expect(book.safeImageUrl, equals(''));
      });
    });

    group('authorsString getter', () {
      test('should return comma-separated author names', () {
        expect(testBook.authorsString, equals('John Doe, Jane Smith'));
      });

      test('should return single author name', () {
        final book = testBook.copyWith(
          authors: [
            const Author(
              name: 'Single Author',
              birthYear: 1990,
              deathYear: null,
            ),
          ],
        );

        expect(book.authorsString, equals('Single Author'));
      });

      test('should return "Unknown Author" for empty authors list', () {
        final book = testBook.copyWith(authors: []);

        expect(book.authorsString, equals('Unknown Author'));
      });

      test('should handle multiple authors correctly', () {
        final authors = [
          const Author(name: 'Author One', birthYear: 1970, deathYear: null),
          const Author(name: 'Author Two', birthYear: 1980, deathYear: null),
          const Author(name: 'Author Three', birthYear: 1990, deathYear: null),
        ];
        final book = testBook.copyWith(authors: authors);

        expect(
          book.authorsString,
          equals('Author One, Author Two, Author Three'),
        );
      });
    });

    group('primarySubject getter', () {
      test('should return first subject from subjects list', () {
        expect(testBook.primarySubject, equals('Fiction'));
      });

      test('should return "No Subject" for empty subjects list', () {
        final book = testBook.copyWith(subjects: []);

        expect(book.primarySubject, equals('No Subject'));
      });

      test('should return first subject even with multiple subjects', () {
        final book = testBook.copyWith(
          subjects: ['Science Fiction', 'Technology', 'Future'],
        );

        expect(book.primarySubject, equals('Science Fiction'));
      });
    });

    group('copyWith method', () {
      test('should create copy with updated fields', () {
        final updatedBook = testBook.copyWith(
          title: 'Updated Title',
          downloadCount: 2000,
        );

        expect(updatedBook.title, equals('Updated Title'));
        expect(updatedBook.downloadCount, equals(2000));
        expect(updatedBook.id, equals(testBook.id)); // unchanged
        expect(updatedBook.authors, equals(testBook.authors)); // unchanged
      });

      test(
        'should create copy with all same values when no parameters provided',
        () {
          final copiedBook = testBook.copyWith();

          expect(copiedBook.id, equals(testBook.id));
          expect(copiedBook.title, equals(testBook.title));
          expect(copiedBook.authors, equals(testBook.authors));
          expect(copiedBook.subjects, equals(testBook.subjects));
          expect(copiedBook.downloadCount, equals(testBook.downloadCount));
        },
      );

      test('should handle null values correctly', () {
        final book = testBook.copyWith(subjects: [], authors: []);

        expect(book.subjects, isEmpty);
        expect(book.authors, isEmpty);
        expect(book.authorsString, equals('Unknown Author'));
        expect(book.primarySubject, equals('No Subject'));
      });
    });

    group('Equality and props', () {
      test('should be equal for books with same properties', () {
        final book1 = Book(
          id: 1,
          title: 'Test',
          authors: testAuthors,
          subjects: ['Fiction'],
          bookshelves: ['Shelf'],
          languages: ['en'],
          copyright: false,
          mediaType: 'Text',
          formats: {'text/plain': 'url'},
          downloadCount: 100,
        );

        final book2 = Book(
          id: 1,
          title: 'Test',
          authors: testAuthors,
          subjects: ['Fiction'],
          bookshelves: ['Shelf'],
          languages: ['en'],
          copyright: false,
          mediaType: 'Text',
          formats: {'text/plain': 'url'},
          downloadCount: 100,
        );

        expect(book1, equals(book2));
      });

      test('should not be equal for books with different properties', () {
        final book1 = testBook;
        final book2 = testBook.copyWith(title: 'Different Title');

        expect(book1, isNot(equals(book2)));
      });
    });

    group('JSON serialization', () {
      test('should create Book from JSON', () {
        final json = {
          'id': 1,
          'title': 'Test Book',
          'authors': [
            {'name': 'John Doe', 'birth_year': 1980, 'death_year': null},
          ],
          'subjects': ['Fiction'],
          'bookshelves': ['Popular'],
          'languages': ['en'],
          'copyright': false,
          'media_type': 'Text',
          'formats': {'text/plain': 'https://example.com/book.txt'},
          'download_count': 1000,
        };

        final book = Book.fromJson(json);

        expect(book.id, equals(1));
        expect(book.title, equals('Test Book'));
        expect(book.authors, hasLength(1));
        expect(book.authors.first.name, equals('John Doe'));
        expect(book.downloadCount, equals(1000));
      });

      test('should convert Book to JSON', () {
        final json = testBook.toJson();

        expect(json['id'], equals(1));
        expect(json['title'], equals('Test Book'));
        expect(json['authors'], isA<List>());
        expect(json['download_count'], equals(1500));
        expect(json['media_type'], equals('Text'));
      });
    });
  });
}
