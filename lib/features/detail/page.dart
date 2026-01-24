import 'package:flutter/material.dart';
import 'package:flutter_md/flutter_md.dart';
import 'package:tanglaw/shared/models/drug.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.drug});

  final Drug drug;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final Markdown _markdown;

  @override
  void initState() {
    super.initState();
    _markdown = Markdown.fromString(widget.drug.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.drug.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: MarkdownWidget(markdown: _markdown),
      ),
    );
  }
}
