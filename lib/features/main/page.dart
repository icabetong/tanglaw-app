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
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when 200px from bottom
      final query = ref.read(searchQueryProvider);
      final locale = ref.read(localeProvider).value ?? 'en';
      ref
          .read(paginatedDrugsProvider((query: query, locale: locale)))
          .loadMore();
    }
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
    final notifier = ref.watch(
      paginatedDrugsProvider((query: query, locale: locale)),
    );

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
        onRefresh: () async {
          final query = ref.read(searchQueryProvider);
          final locale = ref.read(localeProvider).value ?? 'en';
          await ref
              .read(paginatedDrugsProvider((query: query, locale: locale)))
              .refresh();
        },
        child: notifier.error != null
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(child: Text(notifier.error!)),
                  ),
                ],
              )
            : notifier.drugs.isEmpty && notifier.isInitialLoading
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ],
              )
            : ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: notifier.drugs.length + (notifier.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= notifier.drugs.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final drug = notifier.drugs[index];
                  return ListTile(
                    title: Text(drug.name),
                    subtitle: Text(drug.genericName),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(drug: drug),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
