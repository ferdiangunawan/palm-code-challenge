// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookDto _$BookDtoFromJson(Map<String, dynamic> json) => BookDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      authors: (json['authors'] as List<dynamic>)
          .map((e) => AuthorDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      subjects:
          (json['subjects'] as List<dynamic>).map((e) => e as String).toList(),
      bookshelves: (json['bookshelves'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      languages:
          (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      copyright: json['copyright'] as bool,
      mediaType: json['media_type'] as String,
      formats: FormatsDto.fromJson(json['formats'] as Map<String, dynamic>),
      downloadCount: (json['download_count'] as num).toInt(),
    );

Map<String, dynamic> _$BookDtoToJson(BookDto instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authors': instance.authors,
      'subjects': instance.subjects,
      'bookshelves': instance.bookshelves,
      'languages': instance.languages,
      'copyright': instance.copyright,
      'media_type': instance.mediaType,
      'formats': instance.formats,
      'download_count': instance.downloadCount,
    };

AuthorDto _$AuthorDtoFromJson(Map<String, dynamic> json) => AuthorDto(
      name: json['name'] as String,
      birthYear: (json['birth_year'] as num?)?.toInt(),
      deathYear: (json['death_year'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AuthorDtoToJson(AuthorDto instance) => <String, dynamic>{
      'name': instance.name,
      'birth_year': instance.birthYear,
      'death_year': instance.deathYear,
    };

FormatsDto _$FormatsDtoFromJson(Map<String, dynamic> json) => FormatsDto(
      imageJpeg: json['image/jpeg'] as String?,
      textHtml: json['text/html'] as String?,
      applicationEpubZip: json['application/epub+zip'] as String?,
      applicationMobipocketEbook:
          json['application/x-mobipocket-ebook'] as String?,
      textPlain: json['text/plain; charset=utf-8'] as String?,
    );

Map<String, dynamic> _$FormatsDtoToJson(FormatsDto instance) =>
    <String, dynamic>{
      'image/jpeg': instance.imageJpeg,
      'text/html': instance.textHtml,
      'application/epub+zip': instance.applicationEpubZip,
      'application/x-mobipocket-ebook': instance.applicationMobipocketEbook,
      'text/plain; charset=utf-8': instance.textPlain,
    };

BookListResponseDto _$BookListResponseDtoFromJson(Map<String, dynamic> json) =>
    BookListResponseDto(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => BookDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookListResponseDtoToJson(
        BookListResponseDto instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
