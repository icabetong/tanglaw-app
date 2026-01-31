import 'package:tanglaw/shared/models/strapi_object.dart';

class Drug extends StrapiObject {
  final String name;
  final String genericName;
  final String brandNames;
  final String content;

  const Drug({
    required this.name,
    required this.genericName,
    required this.brandNames,
    required this.content,
    // inherited properties
    required super.id,
    required super.documentId,
    required super.createdAt,
    required super.updatedAt,
    required super.publishedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'documentId': documentId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'publishedAt': publishedAt.toIso8601String(),
    'name': name,
    'genericName': genericName,
    'brandNames': brandNames,
    'content': content,
  };

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
        'brandNames': String brandNames,
        'content': String content,
      } =>
        Drug(
          name: name,
          genericName: genericName,
          brandNames: brandNames,
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
