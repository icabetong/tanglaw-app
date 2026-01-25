import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/features/about/page.dart';
import 'package:tanglaw/features/detail/page.dart';
import 'package:tanglaw/features/main/provider_drugs.dart';
import 'package:tanglaw/features/main/provider_search.dart';
import 'package:tanglaw/features/settings/page.dart';
import 'package:tanglaw/features/settings/provider_locale.dart';
import 'package:tanglaw/l10n/app_localizations.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends ConsumerState<MainScreen> {
  final SearchController _controller = SearchController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void onMenuItemSelected(String option) {
    switch (option) {
      case 'settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        break;
      case 'about':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> menuItems = {
      'settings': AppLocalizations.of(context)!.menu_settings,
      'about': AppLocalizations.of(context)!.menu_about,
    };

    final query = ref.watch(searchQueryProvider);
    final localeAsync = ref.watch(localeProvider);
    final locale = localeAsync.value ?? 'en';
    final drugs = ref.watch(drugProvider((query: query, locale: locale)));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: SearchBar(
          controller: _controller,
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.surfaceContainerHigh,
          ),
          constraints: const BoxConstraints(maxHeight: 48, minHeight: 48),
          hintText: AppLocalizations.of(context)!.placeholder_search,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Icon(Icons.search),
          ),
          trailing: [
            if (_controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _controller.clear();
                },
              ),

            // IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            PopupMenuButton<String>(
              itemBuilder: (context) {
                return menuItems.entries.map((entry) {
                  return PopupMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList();
              },
              onSelected: onMenuItemSelected,
            ),
          ],
          onChanged: (value) {
            if (_debounce?.isActive ?? false) _debounce!.cancel();

            _debounce = Timer(const Duration(milliseconds: 500), () {
              ref.read(searchQueryProvider.notifier).updateQuery(value);
            });
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.refresh(drugProvider((query: query, locale: locale)).future),
        child: drugs.when(
          data: (list) => ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: list.data.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(list.data[index].name),
              subtitle: Text(list.data[index].genericName),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(drug: list.data[index]),
                ),
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("$err: $stack")),
        ),
      ),
    );
  }
}
