import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/features/main/provider_drugs.dart';
import 'package:tanglaw/features/settings/provider_locale.dart';
import 'package:tanglaw/l10n/app_localizations.dart';

class LanguageListTile extends ConsumerWidget {
  const LanguageListTile({super.key});

  Widget _languageOption(
    BuildContext context,
    WidgetRef ref,
    String name,
    String code,
    String current,
  ) {
    final isSelected = current == code;

    return SimpleDialogOption(
      onPressed: () {
        ref.read(localeProvider.notifier).setLocale(code);
        ref.read(drugListProvider.notifier).initialize('', code);
        Navigator.pop(context); // Close dialog
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Theme.of(context).primaryColor : null,
              ),
            ),
            if (isSelected) const Icon(Icons.check, size: 20),
          ],
        ),
      ),
    );
  }

  void _showLocaleSelection(
    BuildContext context,
    WidgetRef ref,
    String currentLocale,
  ) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(AppLocalizations.of(context)!.pref_language),
        children: [
          _languageOption(
            context,
            ref,
            AppLocalizations.of(context)!.pref_language_option_en,
            'en',
            currentLocale,
          ),
          _languageOption(
            context,
            ref,
            AppLocalizations.of(context)!.pref_language_option_fil,
            'fil',
            currentLocale,
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code, BuildContext context) {
    switch (code) {
      case 'en':
        return AppLocalizations.of(context)!.pref_language_option_en;
      case 'fil':
        return AppLocalizations.of(context)!.pref_language_option_fil;
      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localAsync = ref.watch(localeProvider);

    // return ListTile(title: const Text("Language"));
    return localAsync.when(
      data: (currentLocale) => ListTile(
        leading: const Icon(Icons.language),
        title: Text(AppLocalizations.of(context)!.pref_language),
        subtitle: Text(_getLanguageName(currentLocale, context)),
        onTap: () => _showLocaleSelection(context, ref, currentLocale),
      ),
      loading: () => ListTile(
        title: Text(AppLocalizations.of(context)!.loading_languages),
      ),
      error: (err, _) => ListTile(title: Text("Error $err")),
    );
  }
}
