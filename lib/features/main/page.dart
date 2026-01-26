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
    // Initialize the notifier on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locale = ref.read(localeProvider).value ?? 'en';
      ref.read(drugListProvider.notifier).initialize('', locale);
    });
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
    final drugState = ref.watch(drugListProvider);

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
              ref.read(drugListProvider.notifier).initialize(value, locale);
            });
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(drugListProvider.notifier).initialize(query, locale);
        },
        child: drugState.error != null
            ? Center(child: Text(drugState.error!))
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: drugState.drugs.length + 1,
                itemBuilder: (context, index) {
                  // show drug items
                  if (index < drugState.drugs.length) {
                    final drug = drugState.drugs[index];
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
                  }

                  if (drugState.loading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (drugState.hasMore) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () =>
                              ref.read(drugListProvider.notifier).loadMore(),
                          child: Text(
                            AppLocalizations.of(context)!.button_load_more,
                          ),
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
      ),
    );
  }
}
