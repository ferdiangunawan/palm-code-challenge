import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:palm_code_challenge/common/constants/index.dart';

part 'author.g.dart';

@HiveType(typeId: HiveTypeIds.author)
@JsonSerializable()
class Author extends Equatable {
  @HiveField(0)
  final String name;

  @HiveField(1)
  @JsonKey(name: 'birth_year')
  final int? birthYear;

  @HiveField(2)
  @JsonKey(name: 'death_year')
  final int? deathYear;

  const Author({required this.name, this.birthYear, this.deathYear});

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);

  @override
  List<Object?> get props => [name, birthYear, deathYear];

  Author copyWith({String? name, int? birthYear, int? deathYear}) {
    return Author(
      name: name ?? this.name,
      birthYear: birthYear ?? this.birthYear,
      deathYear: deathYear ?? this.deathYear,
    );
  }
}
