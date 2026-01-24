class Paginated<T> {
  final List<T> data;

  const Paginated({required this.data});

  factory Paginated.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> raw) parser,
  ) {
    return switch (json) {
      {'data': List data} => Paginated(
        data: data.map((item) => parser(item as Map<String, dynamic>)).toList(),
      ),
      _ => throw const FormatException(
        'Failed to parse StrapiPaginatedResponse',
      ),
    };
  }
}
