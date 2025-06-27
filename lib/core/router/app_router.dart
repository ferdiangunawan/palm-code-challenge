import 'package:go_router/go_router.dart';
import 'package:palm_code_challenge/data/models/index.dart';
import 'package:palm_code_challenge/presentation/book_detail/pages/index.dart';
import 'package:palm_code_challenge/presentation/home/pages/index.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/home', builder: (context, state) => const MainPage()),
      GoRoute(
        path: '/book/:id',
        builder: (context, state) {
          final bookId = int.parse(state.pathParameters['id']!);
          Book? book;

          // Only handle Book objects directly
          if (state.extra != null && state.extra is Book) {
            book = state.extra as Book;
          }

          return BookDetailPage(bookId: bookId, book: book);
        },
      ),
    ],
  );
}
