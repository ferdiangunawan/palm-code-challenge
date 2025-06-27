import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'book_dto.g.dart';

@JsonSerializable()
class BookDto extends Equatable {
  final int id;
  final String title;
  final List<AuthorDto> authors;
  final List<String> subjects;
  final List<String> bookshelves;
  final List<String> languages;
  final bool copyright;
  @JsonKey(name: 'media_type')
  final String mediaType;
  final FormatsDto formats;
  @JsonKey(name: 'download_count')
  final int downloadCount;

  const BookDto({
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

  factory BookDto.fromJson(Map<String, dynamic> json) =>
      _$BookDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BookDtoToJson(this);

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
}

@JsonSerializable()
class AuthorDto extends Equatable {
  final String name;
  @JsonKey(name: 'birth_year')
  final int? birthYear;
  @JsonKey(name: 'death_year')
  final int? deathYear;

  const AuthorDto({required this.name, this.birthYear, this.deathYear});

  factory AuthorDto.fromJson(Map<String, dynamic> json) =>
      _$AuthorDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorDtoToJson(this);

  @override
  List<Object?> get props => [name, birthYear, deathYear];
}

@JsonSerializable()
class FormatsDto extends Equatable {
  @JsonKey(name: 'image/jpeg')
  final String? imageJpeg;
  @JsonKey(name: 'text/html')
  final String? textHtml;
  @JsonKey(name: 'application/epub+zip')
  final String? applicationEpubZip;
  @JsonKey(name: 'application/x-mobipocket-ebook')
  final String? applicationMobipocketEbook;
  @JsonKey(name: 'text/plain; charset=utf-8')
  final String? textPlain;

  const FormatsDto({
    this.imageJpeg,
    this.textHtml,
    this.applicationEpubZip,
    this.applicationMobipocketEbook,
    this.textPlain,
  });

  factory FormatsDto.fromJson(Map<String, dynamic> json) =>
      _$FormatsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FormatsDtoToJson(this);

  @override
  List<Object?> get props => [
    imageJpeg,
    textHtml,
    applicationEpubZip,
    applicationMobipocketEbook,
    textPlain,
  ];
}

@JsonSerializable()
class BookListResponseDto extends Equatable {
  final int count;
  final String? next;
  final String? previous;
  final List<BookDto> results;

  const BookListResponseDto({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory BookListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$BookListResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BookListResponseDtoToJson(this);

  @override
  List<Object?> get props => [count, next, previous, results];
}
