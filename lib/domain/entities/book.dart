import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book extends Equatable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<Author> authors;

  @HiveField(3)
  final List<String> subjects;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final int downloadCount;

  @HiveField(6)
  final bool isLiked;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.subjects,
    this.imageUrl,
    required this.downloadCount,
    this.isLiked = false,
  });

  Book copyWith({
    int? id,
    String? title,
    List<Author>? authors,
    List<String>? subjects,
    String? imageUrl,
    int? downloadCount,
    bool? isLiked,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      subjects: subjects ?? this.subjects,
      imageUrl: imageUrl ?? this.imageUrl,
      downloadCount: downloadCount ?? this.downloadCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  String get authorsText => authors.map((author) => author.name).join(', ');

  @override
  List<Object?> get props => [
    id,
    title,
    authors,
    subjects,
    imageUrl,
    downloadCount,
    isLiked,
  ];
}

@HiveType(typeId: 1)
class Author extends Equatable {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int? birthYear;

  @HiveField(2)
  final int? deathYear;

  const Author({required this.name, this.birthYear, this.deathYear});

  String get lifespan {
    if (birthYear == null && deathYear == null) return '';
    return '(${birthYear ?? '?'} - ${deathYear ?? '?'})';
  }

  @override
  List<Object?> get props => [name, birthYear, deathYear];
}
