class PageResponse<T> {
  final List<T> content;
  final int totalElements;
  final int totalPages;
  final int number;
  final int size;
  final bool last;
  final bool first;
  final bool empty;

  PageResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.number,
    required this.size,
    required this.last,
    required this.first,
    required this.empty,
  });

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PageResponse<T>(
      content:
          (json['content'] as List<dynamic>)
              .map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList(),
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      number: json['number'] ?? 0,
      size: json['size'] ?? 10,
      last: json['last'] ?? true,
      first: json['first'] ?? true,
      empty: json['empty'] ?? true,
    );
  }
}
