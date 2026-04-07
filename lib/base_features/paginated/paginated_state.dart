import 'package:equatable/equatable.dart';

/// Sealed state hierarchy for paginated data (loading, loaded with page info, error, refreshing).
sealed class PaginatedState<T> extends Equatable {
  const PaginatedState();

  @override
  List<Object?> get props => [];
}

final class PaginatedInitial<T> extends PaginatedState<T> {
  const PaginatedInitial();
}

final class PaginatedLoading<T> extends PaginatedState<T> {
  const PaginatedLoading();
}

final class PaginatedLoaded<T> extends PaginatedState<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int pageSize;
  final bool isLoadingMore;
  final T? selectedItem;

  const PaginatedLoaded({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    this.pageSize = 10,
    this.isLoadingMore = false,
    this.selectedItem,
  });

  bool get hasMore => currentPage < totalPages;
  bool get isEmpty => items.isEmpty;

  PaginatedLoaded<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? totalPages,
    int? totalCount,
    int? pageSize,
    bool? isLoadingMore,
    T? selectedItem,
    bool clearSelection = false,
  }) {
    return PaginatedLoaded<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
      pageSize: pageSize ?? this.pageSize,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      selectedItem: clearSelection ? null : selectedItem ?? this.selectedItem,
    );
  }

  @override
  List<Object?> get props => [
        items, currentPage, totalPages, totalCount,
        pageSize, isLoadingMore, selectedItem,
      ];
}

final class PaginatedError<T> extends PaginatedState<T> {
  final String message;
  final List<T>? previousItems;
  final int? previousPage;
  final int? previousTotalPages;
  final int? previousTotalCount;

  const PaginatedError(
    this.message, {
    this.previousItems,
    this.previousPage,
    this.previousTotalPages,
    this.previousTotalCount,
  });

  bool get canRecover => previousItems != null;

  @override
  List<Object?> get props => [
        message, previousItems, previousPage,
        previousTotalPages, previousTotalCount,
      ];
}

final class PaginatedRefreshing<T> extends PaginatedState<T> {
  final List<T> currentItems;

  const PaginatedRefreshing({this.currentItems = const []});

  @override
  List<Object?> get props => [currentItems];
}
