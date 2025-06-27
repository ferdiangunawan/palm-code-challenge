import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:palm_code_challenge/common/constants/index.dart';
import 'package:palm_code_challenge/core/network/index.dart';
import 'package:palm_code_challenge/core/theme/index.dart';
import 'package:palm_code_challenge/data/datasources/index.dart';
import 'package:palm_code_challenge/data/models/index.dart';
import 'package:palm_code_challenge/data/repositories/index.dart';
import 'package:palm_code_challenge/domain/repositories/index.dart';
import 'package:palm_code_challenge/presentation/book_detail/cubit/index.dart';
import 'package:palm_code_challenge/presentation/home/cubit/index.dart';
import 'package:palm_code_challenge/presentation/liked_books/cubit/index.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Core - Register NetworkClient as async singleton
  getIt.registerSingletonAsync<NetworkClient>(() async {
    final client = NetworkClient();
    // Ensure the client is properly initialized
    await client.ensureInitialized();
    return client;
  });

  // Wait for NetworkClient to be ready
  await getIt.isReady<NetworkClient>();

  // Open Hive box
  final likedBooksBox = await Hive.openBox<Book>(HiveBoxNames.likedBooks);
  getIt.registerSingleton<Box<Book>>(likedBooksBox);

  // Data sources
  getIt.registerLazySingleton<BooksRemoteDataSource>(
    () => BooksRemoteDataSource(getIt()),
  );
  getIt.registerLazySingleton<LikedBooksLocalDataSource>(
    () => LikedBooksLocalDataSource(),
  );

  // Repositories
  getIt.registerLazySingleton<BooksRepository>(
    () => BooksRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<LikedBooksRepository>(
    () => LikedBooksRepositoryImpl(getIt()),
  );

  // Cubits
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt(), getIt()));
  getIt.registerFactory<BookDetailCubit>(
    () => BookDetailCubit(getIt(), getIt()),
  );
  getIt.registerFactory<LikedBooksCubit>(() => LikedBooksCubit(getIt()));
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
}
