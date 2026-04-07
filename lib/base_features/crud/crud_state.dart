import 'package:equatable/equatable.dart';

/// Sealed state hierarchy for CRUD operations (loading, loaded, saving, deleting, error).
sealed class CrudState<T> extends Equatable {
  const CrudState();

  @override
  List<Object?> get props => [];
}

final class CrudInitial<T> extends CrudState<T> {
  const CrudInitial();
}

final class CrudLoading<T> extends CrudState<T> {
  const CrudLoading();
}

final class CrudLoaded<T> extends CrudState<T> {
  final List<T> items;
  final List<T> filteredItems;
  final bool? isActiveFilter;
  final T? selectedItem;

  const CrudLoaded({
    required this.items,
    List<T>? filteredItems,
    this.isActiveFilter,
    this.selectedItem,
  }) : filteredItems = filteredItems ?? items;

  CrudLoaded<T> copyWith({
    List<T>? items,
    List<T>? filteredItems,
    bool? isActiveFilter,
    T? selectedItem,
    bool clearSelection = false,
    bool clearIsActiveFilter = false,
  }) {
    return CrudLoaded<T>(
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      isActiveFilter:
          clearIsActiveFilter ? null : isActiveFilter ?? this.isActiveFilter,
      selectedItem: clearSelection ? null : selectedItem ?? this.selectedItem,
    );
  }

  @override
  List<Object?> get props => [items, filteredItems, isActiveFilter, selectedItem];
}

final class CrudError<T> extends CrudState<T> {
  final String message;
  final CrudState<T>? previousState;

  const CrudError(this.message, {this.previousState});

  @override
  List<Object?> get props => [message, previousState];
}

final class CrudSaving<T> extends CrudState<T> {
  const CrudSaving();
}

final class CrudSaved<T> extends CrudState<T> {
  final String message;
  final T? item;

  const CrudSaved(this.message, {this.item});

  @override
  List<Object?> get props => [message, item];
}

final class CrudDeleting<T> extends CrudState<T> {
  const CrudDeleting();
}

final class CrudDeleted<T> extends CrudState<T> {
  final String message;

  const CrudDeleted(this.message);

  @override
  List<Object?> get props => [message];
}
