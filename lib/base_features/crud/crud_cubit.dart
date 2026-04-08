import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/error_mapper.dart';
import 'crud_state.dart';

/// Base cubit for full CRUD operations with filtering, selection, and list management.
///
/// Subclasses must implement [getId] and [fetchItems].
/// Provides [performSave] and [performDelete] for create/update/delete with
/// automatic state transitions (saving/deleting → success → loaded, or error → loaded).
///
/// Helper methods [addToList] and [updateInList] simplify list updates after save operations.
///
/// ```dart
/// class UsersCubit extends CrudCubit<User, int> {
///   final UserRepository _repo;
///   UsersCubit(this._repo);
///
///   @override
///   int getId(User item) => item.id;
///
///   @override
///   Future<List<User>> fetchItems() => _repo.getUsers();
///
///   Future<void> createUser(CreateUserDto dto) => performSave(
///     operation: () => _repo.create(dto),
///     successMessage: 'User created',
///     updateList: (user) => addToList(user),
///   );
///
///   Future<void> deleteUser(int id) => performDelete(
///     operation: () => _repo.delete(id),
///     id: id,
///     successMessage: 'User deleted',
///   );
/// }
/// ```
abstract class CrudCubit<T, Id> extends Cubit<CrudState<T>> {
  List<T> _items = [];

  List<T> get items => _items;
  set items(List<T> value) => _items = value;

  CrudCubit() : super(CrudInitial<T>());

  Id getId(T item);

  bool? getIsActive(T item) => null;

  Future<List<T>> fetchItems();

  Future<void> loadItems() async {
    if (isClosed) return;
    emit(CrudLoading<T>());

    try {
      final result = await fetchItems();
      if (isClosed) return;
      _items = List.unmodifiable(result);
      emit(CrudLoaded<T>(items: _items, filteredItems: _items));
    } catch (e) {
      if (isClosed) return;
      emit(CrudError<T>(ErrorMapper.map(e).message));
    }
  }

  void filterByStatus(bool? isActive) {
    final currentState = state;
    if (currentState is CrudLoaded<T>) {
      final filteredItems = isActive == null
          ? _items
          : _items.where((item) => getIsActive(item) == isActive).toList();
      emit(
        currentState.copyWith(
          filteredItems: filteredItems,
          isActiveFilter: isActive,
          clearIsActiveFilter: isActive == null,
        ),
      );
    }
  }

  void selectItem(T? item) {
    if (state is CrudLoaded<T>) {
      emit((state as CrudLoaded<T>).copyWith(selectedItem: item));
    }
  }

  void clearSelection() {
    if (state is CrudLoaded<T>) {
      emit((state as CrudLoaded<T>).copyWith(clearSelection: true));
    }
  }

  Future<void> performSave({
    required Future<T> Function() operation,
    required String successMessage,
    required List<T> Function(T result) updateList,
  }) async {
    if (isClosed) return;
    emit(CrudSaving<T>());

    try {
      final result = await operation();
      if (isClosed) return;
      _items = List.unmodifiable(updateList(result));
      emit(CrudSaved<T>(successMessage, item: result, items: _items));
    } catch (e) {
      if (isClosed) return;
      emit(CrudError<T>(
        ErrorMapper.map(e).message,
        previousState: CrudLoaded<T>(items: _items),
      ));
    }
  }

  Future<void> performDelete({
    required Future<void> Function() operation,
    required Id id,
    required String successMessage,
  }) async {
    if (isClosed) return;
    emit(CrudDeleting<T>());

    try {
      await operation();
      if (isClosed) return;
      _items = List.unmodifiable(
        _items.where((item) => getId(item) != id).toList(),
      );
      emit(CrudDeleted<T>(successMessage, items: _items));
    } catch (e) {
      if (isClosed) return;
      emit(CrudError<T>(
        ErrorMapper.map(e).message,
        previousState: CrudLoaded<T>(items: _items),
      ));
    }
  }

  List<T> addToList(T item) => [..._items, item];

  List<T> updateInList(T updatedItem) => _items
      .map((item) => getId(item) == getId(updatedItem) ? updatedItem : item)
      .toList();
}
