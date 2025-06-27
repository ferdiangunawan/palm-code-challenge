import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:palm_code_challenge/common/constants/index.dart';
import 'package:palm_code_challenge/common/utils/image_utils.dart';
import 'package:palm_code_challenge/data/models/author.dart';

part 'book.g.dart';

@HiveType(typeId: HiveTypeIds.book)
@JsonSerializable()
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
  final List<String> bookshelves;

  @HiveField(5)
  final List<String> languages;

  @HiveField(6)
  final bool copyright;

  @HiveField(7)
  @JsonKey(name: 'media_type')
  final String mediaType;

  @HiveField(8)
  final Map<String, String> formats;

  @HiveField(9)
  @JsonKey(name: 'download_count')
  final int downloadCount;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.subjects,
    required this.bookshelves,
    required this.languages,
    required this.copyright,
    required this.mediaType,
    required this.formats,
    required this.downloadCount,
  });

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  Map<String, dynamic> toJson() => _$BookToJson(this);

  @override
  List<Object?> get props => [
    id,
    title,
    authors,
    subjects,
    bookshelves,
    languages,
    copyright,
    mediaType,
    formats,
    downloadCount,
  ];

  Book copyWith({
    int? id,
    String? title,
    List<Author>? authors,
    List<String>? subjects,
    List<String>? bookshelves,
    List<String>? languages,
    bool? copyright,
    String? mediaType,
    Map<String, String>? formats,
    int? downloadCount,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      subjects: subjects ?? this.subjects,
      bookshelves: bookshelves ?? this.bookshelves,
      languages: languages ?? this.languages,
      copyright: copyright ?? this.copyright,
      mediaType: mediaType ?? this.mediaType,
      formats: formats ?? this.formats,
      downloadCount: downloadCount ?? this.downloadCount,
    );
  }

  String get imageUrl {
    final originalUrl = formats['image/jpeg'] ?? formats['text/html'];
    return ImageUtils.getSafeImageUrl(originalUrl, bookId: id);
  }

  /// Get a safe image URL, returns empty string if should use local placeholder
  String get safeImageUrl {
    final url = imageUrl;
    return url.isEmpty ? '' : url;
  }

  String get authorsString {
    if (authors.isEmpty) return 'Unknown Author';
    return authors.map((author) => author.name).join(', ');
  }

  String get primarySubject {
    if (subjects.isEmpty) return 'No Subject';
    return subjects.first;
  }
}
