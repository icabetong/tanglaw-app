import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/core/providers/sync_provider.dart';

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
    final syncState = ref.watch(syncProvider);

    return ListTile(
      title: Text(widget.title),
      trailing: syncState.when(
        loading: () => CircularProgressIndicator(),
        error: (err, stack) => const Icon(Icons.warning),
        data: (_) => const Icon(Icons.chevron_right),
      ),
      onTap: () => ref.read(syncProvider.notifier).performSync(widget.locale),
    );
  }
}
