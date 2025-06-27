import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:palm_code_challenge/data/models/book.dart';

part 'books_response.g.dart';

@JsonSerializable()
class BooksResponse extends Equatable {
  final int count;
  final String? next;
  final String? previous;
  final List<Book> results;

  const BooksResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory BooksResponse.fromJson(Map<String, dynamic> json) =>
      _$BooksResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BooksResponseToJson(this);

  @override
  List<Object?> get props => [count, next, previous, results];

  bool get hasMore => next != null;
}
