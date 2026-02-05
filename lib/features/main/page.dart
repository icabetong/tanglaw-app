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
import 'package:tanglaw/shared/const/branding.dart';
import 'package:tanglaw/shared/widgets/empty_view.dart';
import 'package:tanglaw/shared/widgets/paginated_list.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

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
          MaterialPageRoute(
            builder: (context) => const AboutScreen(isWelcome: false),
          ),
        );
        break;
    }
  }

  Widget _renderSearchBar(
    String locale,
    String query,
    InternetStatus? connectionState,
  ) {
    final Map<String, String> menuItems = {
      'settings': AppLocalizations.of(context)!.menu_settings,
      'about': AppLocalizations.of(context)!.menu_about,
    };

    return SearchBar(
      controller: _controller,
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.all(BrandColors.primaryColorSurface),
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

                if (connectionState == InternetStatus.connected) {
                  ref.read(drugListProvider.notifier).initialize('', locale);
                } else {
                  ref.invalidate(storeProvider((query: query, locale: locale)));
                }
              });
            },
          ),

        PopupMenuButton<String>(
          itemBuilder: (context) {
            return menuItems.entries.map((entry) {
              return PopupMenuItem(value: entry.key, child: Text(entry.value));
            }).toList();
          },
          onSelected: onMenuItemSelected,
        ),
      ],
      onChanged: (value) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();

        _debounce = Timer(const Duration(milliseconds: 500), () {
          ref.read(searchQueryProvider.notifier).updateQuery(value);

          if (connectionState == InternetStatus.connected) {
            ref.read(drugListProvider.notifier).initialize(value, locale);
          } else {
            ref.invalidate(storeProvider((query: query, locale: locale)));
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: Theme.of(context).colorScheme.error,
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverLayoutBuilder(
            builder: (context, constraints) {
              final isCollapsed =
                  constraints.scrollOffset > (180 - kToolbarHeight);

              return SliverAppBar(
                pinned: true,
                expandedHeight: 180,
                backgroundColor: BrandColors.primaryColor,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),

                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(isCollapsed ? 56 : 0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: isCollapsed
                        ? Padding(
                            key: const ValueKey('collapsed'),
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: SizedBox(
                              height: 56,
                              child: _renderSearchBar(
                                locale,
                                query,
                                connectionState.value,
                              ),
                            ),
                          )
                        : const SizedBox(key: ValueKey('empty'), height: 0),
                  ),
                ),

                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 40, 8, 0),
                      child: Column(
                        crossAxisAlignment: .center,
                        children: [
                          AnimatedOpacity(
                            opacity: isCollapsed ? 0 : 1,
                            duration: const Duration(milliseconds: 200),
                            child: Image(
                              height: 56,
                              image: AssetImage('assets/logo-white.png'),
                            ),
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            height: 56,
                            child: AnimatedOpacity(
                              opacity: isCollapsed ? 0 : 1,
                              duration: const Duration(milliseconds: 200),
                              child: _renderSearchBar(
                                locale,
                                query,
                                connectionState.value,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          connectionState.when(
            loading: () => SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                child: Text(AppLocalizations.of(context)!.error_generic),
              ),
            ),
            data: (state) {
              if (state == InternetStatus.connected) {
                return DrugPaginatedList(
                  drugState: drugState,
                  query: query,
                  locale: locale,
                );
              }

              return storeAsync.when(
                loading: () => SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SliverFillRemaining(
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.error_generic),
                  ),
                ),
                data: (list) {
                  if (list.isEmpty) {
                    return SliverFillRemaining(
                      child: EmptyViewWidget(
                        title: query.isNotEmpty
                            ? AppLocalizations.of(context)!.status_no_results
                            : AppLocalizations.of(context)!.status_no_drugs,
                      ),
                    );
                  }

                  return SliverList.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ListTile(title: Text('Medicine $index'));
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
