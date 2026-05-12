/// Model standard untuk mengirim filter ke API saat melakukan pagination.
///
/// Biasa di-passing ke UseCase sebagai parameter.
class PaginationFilter {
  final int skip;
  final int limit;
  final String? select;

  const PaginationFilter({this.skip = 1, this.limit = 15, this.select});

  /// Convert to Json/QueryParameters untuk Dio
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'skip': skip, 'limit': limit};

    if (select != null && select!.isNotEmpty) {
      map['select'] = select;
    }

    return map;
  }

  /// Copy with helper
  PaginationFilter copyWith({int? skip, int? limit, String? select}) {
    return PaginationFilter(
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      select: select ?? this.select,
    );
  }
}
