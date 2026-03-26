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
    final pageData = json['page'] as Map<String, dynamic>? ?? {};
    return PageResponse<T>(
      content:
          (json['content'] as List<dynamic>?)
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ?? [],
      totalElements: pageData['totalElements'] ?? json['totalElements'] ?? 0,
      totalPages: pageData['totalPages'] ?? json['totalPages'] ?? 0,
      number: pageData['number'] ?? json['number'] ?? 0,
      size: pageData['size'] ?? json['size'] ?? 10,
      last: pageData['last'] ?? json['last'] ?? true,
      first: pageData['first'] ?? json['first'] ?? true,
      empty: pageData['empty'] ?? json['empty'] ?? true,
    );
  }
}
