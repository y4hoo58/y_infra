import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/error_mapper.dart';
import 'base_list_state.dart';

abstract class BaseListCubit<T> extends Cubit<BaseListState<T>> {
  BaseListCubit() : super(const ListInitial());

  Future<List<T>> fetchItems();

  ListLoaded<T> createLoadedState(List<T> items) => ListLoaded<T>(items: items);

  Future<void> loadItems() async {
    if (isClosed) return;
    emit(ListLoading<T>());

    try {
      final items = await fetchItems();
      if (isClosed) return;
      emit(createLoadedState(items));
    } catch (e) {
      if (isClosed) return;
      emit(ListError<T>(error: ErrorMapper.map(e)));
    }
  }

  Future<void> refresh() async => loadItems();

  void updateItem(bool Function(T item) test, T updatedItem) {
    if (state is! ListLoaded<T>) return;
    final current = state as ListLoaded<T>;
    final updatedItems = current.items
        .map((item) => test(item) ? updatedItem : item)
        .toList();
    emit(current.copyWith(items: updatedItems));
  }

  void removeItem(bool Function(T item) test) {
    if (state is! ListLoaded<T>) return;
    final current = state as ListLoaded<T>;
    final updatedItems = current.items.where((item) => !test(item)).toList();
    emit(current.copyWith(items: updatedItems));
  }

  void recoverFromError() {
    final currentState = state;
    if (currentState is ListError<T> && currentState.canRecover) {
      emit(createLoadedState(currentState.previousItems!));
    }
  }
}
