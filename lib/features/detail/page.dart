import 'package:flutter/material.dart';
import 'package:flutter_md/flutter_md.dart';
import 'package:tanglaw/l10n/app_localizations.dart';
import 'package:tanglaw/shared/models/drug.dart';
import 'package:tanglaw/shared/models/markdown_section.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.drug});

  final Drug drug;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<MarkdownSection> _sections = [];

  @override
  void initState() {
    super.initState();
    _sections = MarkdownSection.parseMarkdown(widget.drug.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.drug.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              shape: Border(),
              title: Text(AppLocalizations.of(context)!.placeholder_brands),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(widget.drug.brandNames),
                ),
              ],
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _sections.length,
              itemBuilder: (content, index) {
                final section = _sections[index];
                return ExpansionTile(
                  shape: Border(),
                  title: Text(section.heading),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: MarkdownWidget(markdown: section.markdown),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
