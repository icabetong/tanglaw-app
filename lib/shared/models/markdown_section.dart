import 'package:flutter_md/flutter_md.dart';

class MarkdownSection {
  final int level;
  final String heading;
  final String body;
  final Markdown markdown;

  MarkdownSection({
    required this.level,
    required this.heading,
    required this.body,
    required this.markdown,
  });

  @override
  String toString() => 'Level $level | $heading\n----\n$body\n';

  static List<MarkdownSection> parseMarkdown(String raw) {
    final headingRegex = RegExp(r'^#{1,6}\s.+$', multiLine: true);
    final matches = headingRegex.allMatches(raw).toList();

    if (matches.isEmpty) return [];

    List<MarkdownSection> sections = [];

    for (int i = 0; i < matches.length; i++) {
      final match = matches[i];

      final start = match.start;
      final end = (i + 1 < matches.length) ? matches[i + 1].start : raw.length;

      final sectionText = raw.substring(start, end).trim();
      final headingLine = sectionText.split('\n').first.trim();

      final level = headingLine.indexOf(' ');
      final heading = headingLine.substring(level + 1).trim();

      final body = sectionText.substring(headingLine.length).trim();
      final markdown = Markdown.fromString(body);

      sections.add(
        MarkdownSection(
          level: level,
          heading: heading,
          body: body,
          markdown: markdown,
        ),
      );
    }
    return sections;
  }
}
