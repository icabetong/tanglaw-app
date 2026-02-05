import 'package:flutter/material.dart';
import 'package:flutter_md/flutter_md.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/features/about/provider_content.dart';
import 'package:tanglaw/features/main/page.dart';
import 'package:tanglaw/l10n/app_localizations.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key, required this.isWelcome});

  final bool isWelcome;

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    final contentAsync = ref.watch(aboutSingleTypeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.route_about)),
      body: contentAsync.when(
        data: (content) {
          final markdown = Markdown.fromString(content.data.content);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: MarkdownWidget(markdown: markdown),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text(AppLocalizations.of(context)!.error_generic)),
      ),
      floatingActionButton: widget.isWelcome
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MainScreen()),
                (_) => false,
              ),
              icon: Icon(Icons.chevron_right_rounded),
              label: Text(AppLocalizations.of(context)!.button_continue),
            )
          : null,
    );
  }
}
