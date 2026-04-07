import 'package:flutter_bloc/flutter_bloc.dart';

/// A mixin that adds search, sort, and filter state to any Cubit.
///
/// Requires the cubit to implement [onFiltersChanged] which is called
/// whenever filters are modified (e.g. to trigger a refresh).
///
/// ```dart
/// class ProductsCubit extends BaseListCubit<Product> with FilterableMixin {
///   @override
///   void onFiltersChanged() => refresh();
///
///   @override
///   Future<List<Product>> fetchItems() =>
///     repo.getProducts(search: searchQuery, sortBy: sortBy);
/// }
/// ```
mixin FilterableMixin<TState> on Cubit<TState> {
  String? _searchQuery;
  String? _sortBy;
  bool _sortDesc = false;
  bool? _activeFilter;

  String? get searchQuery => _searchQuery;
  String? get sortBy => _sortBy;
  bool get sortDescending => _sortDesc;
  bool? get activeFilter => _activeFilter;

  /// Called after any filter change. Implement to trigger a data reload.
  void onFiltersChanged();

  /// Override to reset entity-specific filters in [clearFilters].
  void resetEntityFilters() {}

  void search(String query) {
    _searchQuery = query.isEmpty ? null : query;
    onFiltersChanged();
  }

  void sort(String? field, {bool descending = false}) {
    _sortBy = field;
    _sortDesc = descending;
    onFiltersChanged();
  }

  void filterByActive(bool? isActive) {
    _activeFilter = isActive;
    onFiltersChanged();
  }

  void setFilters({
    String? searchQuery,
    bool clearSearch = false,
    String? sortBy,
    bool? sortDescending,
    bool? activeFilter,
  }) {
    if (clearSearch) {
      _searchQuery = null;
    } else if (searchQuery != null) {
      _searchQuery = searchQuery.isEmpty ? null : searchQuery;
    }
    if (sortBy != null) _sortBy = sortBy;
    if (sortDescending != null) _sortDesc = sortDescending;
    if (activeFilter != null) _activeFilter = activeFilter;
  }

  void clearFilters() {
    _searchQuery = null;
    _sortBy = null;
    _sortDesc = false;
    _activeFilter = null;
    resetEntityFilters();
    onFiltersChanged();
  }
}
