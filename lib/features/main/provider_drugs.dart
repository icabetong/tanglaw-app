import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/core/repository/drugs.dart';
import 'package:tanglaw/core/network/api_client.dart';
import 'package:tanglaw/shared/models/drug.dart';

class PaginatedDrugsNotifier extends ChangeNotifier {
  final String query;
  final String locale;
  final DrugsRepository repository;

  List<Drug> drugs = [];
  bool isLoadingMore = false;
  bool hasMore = true;
  int currentPage = 1;
  String? error;
  bool isInitialLoading = true;

  PaginatedDrugsNotifier({
    required this.query,
    required this.locale,
    required this.repository,
  }) {
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    isInitialLoading = true;
    notifyListeners();
    await _loadPage(1);
    isInitialLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    notifyListeners();
    await _loadPage(currentPage + 1);
    isLoadingMore = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadPage(1);
  }

  Future<void> _loadPage(int page) async {
    try {
      final response = await repository.fetchList(
        query: query,
        locale: locale,
        page: page,
        pageSize: 20,
      );

      if (page == 1) {
        drugs = response.data;
      } else {
        drugs = [...drugs, ...response.data];
      }

      hasMore = response.data.length >= 20;
      currentPage = page;
      error = null;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}

final paginatedDrugsProvider =
    Provider.family<PaginatedDrugsNotifier, ({String query, String locale})>((
      ref,
      params,
    ) {
      final client = ApiClient.getInstance();
      final repository = DrugsRepository.getInstance(client);

      final notifier = PaginatedDrugsNotifier(
        query: params.query,
        locale: params.locale,
        repository: repository,
      );

      ref.onDispose(() {
        notifier.dispose();
      });

      return notifier;
    });
