class StrapiObject {
  final int id;
  final String documentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;

  const StrapiObject({
    required this.id,
    required this.documentId,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory StrapiObject.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'documentId': String documentId,
        'createdAt': String createdAt,
        'updatedAt': String updatedAt,
        'publishedAt': String publishedAt,
      } =>
        StrapiObject(
          id: id,
          documentId: documentId,
          createdAt: DateTime.parse(createdAt),
          updatedAt: DateTime.parse(updatedAt),
          publishedAt: DateTime.parse(publishedAt),
        ),
      _ => throw const FormatException('Failed to parse StrapiObject'),
    };
  }
}
