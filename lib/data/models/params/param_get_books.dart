import 'package:equatable/equatable.dart';

class ParamGetBooks extends Equatable {
  final int page;
  final String? search;

  const ParamGetBooks({this.page = 1, this.search});

  ParamGetBooks copyWith({int? page, String? search}) {
    return ParamGetBooks(
      page: page ?? this.page,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [page, search];
}
