import 'paginated_cubit.dart';

mixin FilterableMixin<T> on PaginatedCubit<T> {
  String? _searchQuery;
  String? _sortBy;
  bool _sortDesc = false;
  bool? _activeFilter;

  String? get searchQuery => _searchQuery;
  String? get sortBy => _sortBy;
  bool get sortDescending => _sortDesc;
  bool get sortDesc => _sortDesc;
  bool? get activeFilter => _activeFilter;

  void search(String query) {
    _searchQuery = query.isEmpty ? null : query;
    refresh();
  }

  void sort(String? field, {bool descending = false}) {
    _sortBy = field;
    _sortDesc = descending;
    refresh();
  }

  void filterByActive(bool? isActive) {
    _activeFilter = isActive;
    refresh();
  }

  void clearFilters() {
    _searchQuery = null;
    _sortBy = null;
    _sortDesc = false;
    _activeFilter = null;
    resetEntityFilters();
    refresh();
  }

  void resetEntityFilters() {}

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
}

abstract class FilterablePaginatedCubit<T> extends PaginatedCubit<T>
    with FilterableMixin<T> {
  FilterablePaginatedCubit({super.pageSize});
}
