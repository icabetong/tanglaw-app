import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanglaw/core/repository/drugs.dart';
import 'package:tanglaw/core/network/api_client.dart';
import 'package:tanglaw/shared/models/drug.dart';

const pageSizeLimit = 25;

class DrugListState {
  final List<Drug> drugs;
  final bool loading;
  final bool hasMore;
  final int currentPage;
  final String? error;

  DrugListState({
    this.drugs = const [],
    this.loading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
  });

  DrugListState copyWith({
    List<Drug>? drugs,
    bool? loading,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return DrugListState(
      drugs: drugs ?? this.drugs,
      loading: loading ?? this.loading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error ?? this.error,
    );
  }
}

class DrugListNotifier extends Notifier<DrugListState> {
  late String _query;
  late String _locale;

  @override
  DrugListState build() {
    return DrugListState();
  }

  void initialize(String query, String locale) {
    _query = query;
    _locale = locale;
    loadInitial();
  }

  Future<void> loadInitial() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final client = ApiClient.getInstance();
      final repository = DrugsRepository.getInstance(client);

      final response = await repository.fetchList(
        locale: _locale,
        query: _query,
        page: 1,
        pageSize: pageSizeLimit,
      );
      state = state.copyWith(
        drugs: response.data,
        loading: false,
        hasMore:
            response.data.length >=
            (response.meta.paginate?.pageSize ?? pageSizeLimit),
        currentPage: 1,
      );
    } catch (e) {
      debugPrint(e.toString());
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.loading || !state.hasMore) return;

    state = state.copyWith(loading: true);
    try {
      final client = ApiClient.getInstance();
      final repository = DrugsRepository.getInstance(client);

      final response = await repository.fetchList(
        query: _query,
        locale: _locale,
        page: state.currentPage + 1,
        pageSize: pageSizeLimit,
      );

      final newList = response.data;
      state = state.copyWith(
        drugs: [...state.drugs, ...newList],
        loading: false,
        hasMore:
            newList.length >=
            (response.meta.paginate?.pageSize ?? pageSizeLimit),
        currentPage: state.currentPage + 1,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final drugListProvider = NotifierProvider<DrugListNotifier, DrugListState>(
  DrugListNotifier.new,
);
