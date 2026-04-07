/// Wraps a page of items with pagination metadata (page number, totals)
/// and provides factory parsing from JSON.
class PaginatedResponse<T> {
  final List<T> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  const PaginatedResponse({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  List<T> get data => items;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final itemsList = json['items'] as List<dynamic>?;
    return PaginatedResponse<T>(
      items: itemsList
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ??
          <T>[],
      pageNumber: json['pageNumber'] as int? ?? json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      totalCount: json['totalCount'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }

  bool get hasNextPage => pageNumber < totalPages;
  bool get hasPreviousPage => pageNumber > 1;
  bool get isEmpty => items.isEmpty;
  int get length => items.length;
}
