/// Model standard untuk mengirim filter ke API saat melakukan pagination.
///
/// Biasa di-passing ke UseCase sebagai parameter.
class PaginationFilter {
  final int skip;
  final int limit;
  final String? search;

  const PaginationFilter({this.skip = 1, this.limit = 15, this.search});

  /// Convert to Json/QueryParameters untuk Dio
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'skip': skip, 'limit': limit};

    if (search != null && search!.isNotEmpty) {
      map['q'] = search;
    }

    return map;
  }

  /// Copy with helper
  PaginationFilter copyWith({int? skip, int? limit, String? search}) {
    return PaginationFilter(
      search: search ?? this.search,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }
}
