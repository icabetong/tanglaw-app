import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:tanglaw/core/providers/connectivity.dart';
import 'package:tanglaw/features/about/page.dart';
import 'package:tanglaw/features/main/provider_drugs.dart';
import 'package:tanglaw/features/main/provider_store.dart';
import 'package:tanglaw/features/main/provider_search.dart';
import 'package:tanglaw/features/settings/page.dart';
import 'package:tanglaw/features/settings/provider_locale.dart';
import 'package:tanglaw/l10n/app_localizations.dart';
import 'package:tanglaw/shared/widgets/drug_list_tile.dart';
import 'package:tanglaw/shared/widgets/empty_view.dart';
import 'package:tanglaw/shared/widgets/paginated_list.dart';

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

    final connectionState = ref.watch(internetStatusProvider);
    final drugState = ref.watch(drugListProvider);
    final query = ref.watch(searchQueryProvider);
    final localeAsync = ref.watch(localeProvider);
    final locale = localeAsync.value ?? 'en';
    final storeAsync = ref.watch(storeProvider((query: query, locale: locale)));

    ref.listen<AsyncValue<InternetStatus>>(internetStatusProvider, (
      previous,
      next,
    ) {
      next.whenData((status) {
        if (status == InternetStatus.disconnected) {
          ref.invalidate(storeProvider((query: query, locale: locale)));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.status_no_internet),
              backgroundColor: Colors.red,
              duration: Duration(days: 1),
              showCloseIcon: false,
            ),
          );
        } else if (status == InternetStatus.connected &&
            previous?.value == InternetStatus.disconnected) {
          ref.read(drugListProvider.notifier).initialize(query, locale);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.status_has_internet),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    });

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

                  if (_debounce?.isActive ?? false) _debounce!.cancel();

                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    ref.read(searchQueryProvider.notifier).updateQuery('');

                    if (connectionState.value == InternetStatus.connected) {
                      ref
                          .read(drugListProvider.notifier)
                          .initialize('', locale);
                    } else {
                      ref.invalidate(
                        storeProvider((query: query, locale: locale)),
                      );
                    }
                  });
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

              if (connectionState.value == InternetStatus.connected) {
                ref.read(drugListProvider.notifier).initialize(value, locale);
              } else {
                ref.invalidate(storeProvider((query: query, locale: locale)));
              }
            });
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final status = connectionState.value;
          if (status == InternetStatus.connected) {
            ref.read(drugListProvider.notifier).initialize(query, locale);
          } else {
            ref.invalidate(storeProvider((query: query, locale: locale)));
          }
        },
        child: connectionState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("$err: $stack")),
          data: (state) {
            if (state == InternetStatus.connected) {
              return DrugPaginatedList(
                drugState: drugState,
                query: query,
                locale: locale,
              );
            }

            return storeAsync.when(
              data: (list) {
                if (list.isEmpty) {
                  return EmptyViewWidget(
                    title: query.isNotEmpty
                        ? AppLocalizations.of(context)!.status_no_results
                        : AppLocalizations.of(context)!.status_no_drugs,
                  );
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final drug = list[index];
                    return DrugListTile(drug: drug);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text("$err: $stack")),
            );
          },
        ),
      ),
    );
  }
}
