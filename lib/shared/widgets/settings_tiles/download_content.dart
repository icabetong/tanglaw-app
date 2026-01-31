import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tanglaw/core/providers/last_sync_provider.dart';
import 'package:tanglaw/core/providers/localized_data.dart';
import 'package:tanglaw/core/providers/sync_provider.dart';
import 'package:tanglaw/l10n/app_localizations.dart';

class DownloadContentListTile extends ConsumerStatefulWidget {
  const DownloadContentListTile({
    super.key,
    required this.title,
    required this.locale,
  });

  final String locale;
  final String title;

  @override
  ConsumerState<DownloadContentListTile> createState() =>
      _DownloadContentListTileState();
}

class _DownloadContentListTileState
    extends ConsumerState<DownloadContentListTile> {
  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(syncProvider(widget.locale));
    final lastSync = ref.watch(lastSyncProvider(widget.locale));
    final totalInDatabase = ref.watch(
      localizedDataAvailabilityProvider(widget.locale),
    );

    return ListTile(
      enabled: (totalInDatabase.value ?? 0) > 0,
      title: Text(widget.title),
      subtitle: Text(
        lastSync.value != null
            ? AppLocalizations.of(context)!.status_last_sync_date(
                DateFormat.yMd().add_jm().format(lastSync.value!),
              )
            : AppLocalizations.of(
                context,
              )!.status_n_available(totalInDatabase.value ?? 0),
      ),
      trailing: syncState.when(
        loading: () => CircularProgressIndicator(),
        error: (err, stack) => const Icon(Icons.warning_amber_rounded),
        data: (_) => const Icon(Icons.chevron_right_rounded),
      ),
      onTap: () => ref
          .read(syncProvider(widget.locale).notifier)
          .performSync(widget.locale),
    );
  }
}
