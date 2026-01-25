import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/core/network/api_client.dart';
import 'package:tanglaw/core/repository/single_types.dart';
import 'package:tanglaw/shared/models/strapi_object.dart';
import 'package:tanglaw/shared/models/strapi_response.dart';

class AboutSingleType extends StrapiObject {
  final String title;
  final String content;

  AboutSingleType({
    required super.id,
    required super.documentId,
    required super.createdAt,
    required super.updatedAt,
    required super.publishedAt,
    required this.title,
    required this.content,
  });

  factory AboutSingleType.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'title': String title,
        'content': String content,
        'id': int id,
        'documentId': String documentId,
        'createdAt': String createdAt,
        'updatedAt': String updatedAt,
        'publishedAt': String publishedAt,
      } =>
        AboutSingleType(
          title: title,
          content: content,
          id: id,
          documentId: documentId,
          createdAt: DateTime.parse(createdAt),
          updatedAt: DateTime.parse(updatedAt),
          publishedAt: DateTime.parse(publishedAt),
        ),
      _ => throw const FormatException('Failed to format AboutSingleType'),
    };
  }
}

final aboutSingleTypeProvider = FutureProvider<StrapiResponse<AboutSingleType>>(
  (ref) async {
    final client = ApiClient.getInstance();
    final repository = SingleTypesRepository.getInstance(client);

    final aboutSingleType = await repository.fetchByKey(
      'about',
      (json) => AboutSingleType.fromJson(json),
    );
    return aboutSingleType;
  },
);
