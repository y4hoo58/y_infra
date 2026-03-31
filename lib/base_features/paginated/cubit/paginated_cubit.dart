import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/network/objects/paginated_response.dart';
import '../../../core/errors/error_mapper.dart';
import 'paginated_state.dart';

abstract class PaginatedCubit<T> extends Cubit<PaginatedState<T>> {
  List<T> _items = [];

  List<T> get items => _items;

  final int pageSize;

  PaginatedCubit({this.pageSize = 10}) : super(PaginatedInitial<T>());

  int getId(T item);

  Future<PaginatedResponse<T>> fetchPage(int page, int pageSize);

  Future<void> loadInitial() async {
    if (isClosed) return;
    emit(PaginatedLoading<T>());

    try {
      final response = await fetchPage(1, pageSize);
      if (isClosed) return;

      _items = List.from(response.items);
      emit(PaginatedLoaded<T>(
        items: _items,
        currentPage: response.pageNumber,
        totalPages: response.totalPages,
        totalCount: response.totalCount,
        pageSize: response.pageSize,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(PaginatedError<T>(ErrorMapper.map(e).message));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! PaginatedLoaded<T>) return;
    if (currentState.isLoadingMore || !currentState.hasMore) return;
    if (isClosed) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.currentPage + 1;
      final response = await fetchPage(nextPage, pageSize);
      if (isClosed) return;

      _items = List.from([..._items, ...response.items]);
      emit(PaginatedLoaded<T>(
        items: _items,
        currentPage: response.pageNumber,
        totalPages: response.totalPages,
        totalCount: response.totalCount,
        pageSize: response.pageSize,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(PaginatedError<T>(
        ErrorMapper.map(e).message,
        previousItems: _items,
        previousPage: currentState.currentPage,
        previousTotalPages: currentState.totalPages,
        previousTotalCount: currentState.totalCount,
      ));
    }
  }

  void onBeforeRefresh() {}

  Future<void> refresh() async {
    if (isClosed) return;
    onBeforeRefresh();
    emit(PaginatedRefreshing<T>(currentItems: _items));

    try {
      final response = await fetchPage(1, pageSize);
      if (isClosed) return;

      _items = List.from(response.items);
      emit(PaginatedLoaded<T>(
        items: _items,
        currentPage: response.pageNumber,
        totalPages: response.totalPages,
        totalCount: response.totalCount,
        pageSize: response.pageSize,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(PaginatedError<T>(
        ErrorMapper.map(e).message,
        previousItems: _items,
        previousPage: 1,
      ));
    }
  }

  void recoverFromError() {
    final currentState = state;
    if (currentState is PaginatedError<T> && currentState.canRecover) {
      emit(PaginatedLoaded<T>(
        items: currentState.previousItems!,
        currentPage: currentState.previousPage ?? 1,
        totalPages: currentState.previousTotalPages ?? 1,
        totalCount: currentState.previousTotalCount ?? 0,
        pageSize: pageSize,
      ));
    }
  }

  void selectItem(T? item) {
    if (state is PaginatedLoaded<T>) {
      emit((state as PaginatedLoaded<T>).copyWith(selectedItem: item));
    }
  }

  void clearSelection() {
    if (state is PaginatedLoaded<T>) {
      emit((state as PaginatedLoaded<T>).copyWith(clearSelection: true));
    }
  }

  void updateItem(T updatedItem) {
    if (state is PaginatedLoaded<T>) {
      final currentState = state as PaginatedLoaded<T>;
      _items = _items
          .map((item) => getId(item) == getId(updatedItem) ? updatedItem : item)
          .toList();
      emit(currentState.copyWith(items: _items));
    }
  }

  void removeItem(int id) {
    if (state is PaginatedLoaded<T>) {
      final currentState = state as PaginatedLoaded<T>;
      _items = _items.where((item) => getId(item) != id).toList();
      emit(currentState.copyWith(
        items: _items,
        totalCount: currentState.totalCount - 1,
      ));
    }
  }

  void prependItem(T item) {
    if (state is PaginatedLoaded<T>) {
      final currentState = state as PaginatedLoaded<T>;
      _items = [item, ..._items];
      emit(currentState.copyWith(
        items: _items,
        totalCount: currentState.totalCount + 1,
      ));
    }
  }
}
