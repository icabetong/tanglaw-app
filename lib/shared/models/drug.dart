import 'package:tanglaw/shared/models/strapi_object.dart';

class Drug extends StrapiObject {
  final String name;
  final String genericName;
  final String content;

  const Drug({
    required super.id,
    required super.documentId,
    required super.createdAt,
    required super.updatedAt,
    required super.publishedAt,
    required this.name,
    required this.genericName,
    required this.content,
  });

  factory Drug.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'documentId': String documentId,
        'createdAt': String createdAt,
        'updatedAt': String updatedAt,
        'publishedAt': String publishedAt,
        'name': String name,
        'genericName': String genericName,
        'content': String content,
      } =>
        Drug(
          name: name,
          genericName: genericName,
          content: content,
          id: id,
          documentId: documentId,
          createdAt: DateTime.parse(createdAt),
          updatedAt: DateTime.parse(updatedAt),
          publishedAt: DateTime.parse(publishedAt),
        ),
      _ => throw const FormatException('Failed to parse Drug'),
    };
  }
}
