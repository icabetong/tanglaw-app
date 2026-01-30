import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/features/detail/page.dart';
import 'package:tanglaw/features/main/provider_drugs.dart';

import 'package:tanglaw/l10n/app_localizations.dart';

class DrugPaginatedList extends ConsumerWidget {
  final DrugListState drugState;
  final String query;
  final String locale;

  const DrugPaginatedList({
    super.key,
    required this.drugState,
    required this.query,
    required this.locale,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (drugState.error != null) {
      debugPrint(drugState.error);
      return Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Text(AppLocalizations.of(context)!.error_generic),
            TextButton(
              onPressed: () =>
                  ref.read(drugListProvider.notifier).initialize(query, locale),
              child: Text(AppLocalizations.of(context)!.button_refresh),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
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
              MaterialPageRoute(builder: (context) => DetailScreen(drug: drug)),
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
                onPressed: () => ref.read(drugListProvider.notifier).loadMore(),
                child: Text(AppLocalizations.of(context)!.button_load_more),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
