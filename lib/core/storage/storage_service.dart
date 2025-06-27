import 'package:hive_flutter/hive_flutter.dart';
import 'package:palm_code_challenge/common/constants/index.dart';
import 'package:palm_code_challenge/data/models/index.dart';

class StorageService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(AuthorAdapter());
    Hive.registerAdapter(BookAdapter());

    // Open boxes
    await Hive.openBox<Book>(HiveBoxNames.likedBooks);
  }

  static Box<Book> get likedBooksBox => Hive.box<Book>(HiveBoxNames.likedBooks);

  static Future<void> close() async {
    await Hive.close();
  }
}
