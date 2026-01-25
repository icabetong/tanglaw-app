class Paginate {
  final int page;
  final int pageCount;
  final int pageSize;
  final int total;

  Paginate({
    required this.page,
    required this.pageCount,
    required this.pageSize,
    required this.total,
  });

  factory Paginate.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'page': int page,
        'pageCount': int pageCount,
        'pageSize': int pageSize,
        'total': int total,
      } =>
        Paginate(
          page: page,
          pageCount: pageCount,
          pageSize: pageSize,
          total: total,
        ),
      _ => throw const FormatException('Failed to parse Paginate'),
    };
  }
}

class Meta {
  final Paginate? paginate;

  Meta({required this.paginate});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'pagination': Map<String, dynamic> paginationJson} => Meta(
        paginate: Paginate.fromJson(paginationJson),
      ),
      _ => Meta(paginate: null),
    };
  }
}

class StrapiResponse<T> {
  final T data;
  final Meta meta;

  const StrapiResponse({required this.data, required this.meta});

  factory StrapiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return switch (json) {
      {'data': var data, 'meta': Map<String, dynamic> metaJson} =>
        StrapiResponse(data: fromJsonT(data), meta: Meta.fromJson(metaJson)),
      _ => throw const FormatException('Failed to parse StrapiResponse'),
    };
  }
}
