import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/features/main/provider_drugs.dart';
import 'package:tanglaw/features/main/provider_search.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
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

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final drugs = ref.watch(drugProvider(query));

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
          hintText: 'Search',
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

            IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
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
        onRefresh: () => ref.refresh(drugProvider(query).future),
        child: drugs.when(
          data: (list) => ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: list.data.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(list.data[index].name),
              subtitle: Text(list.data[index].genericName),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("$err: $stack")),
        ),
      ),
    );
  }
}
