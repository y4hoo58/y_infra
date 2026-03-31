import 'package:equatable/equatable.dart';

import '../../core/errors/app_error.dart';

sealed class BaseListState<T> extends Equatable {
  const BaseListState();

  @override
  List<Object?> get props => [];
}

base class ListInitial<T> extends BaseListState<T> {
  const ListInitial();
}

base class ListLoading<T> extends BaseListState<T> {
  const ListLoading();
}

base class ListLoaded<T> extends BaseListState<T> {
  final List<T> items;

  const ListLoaded({required this.items});

  bool get isEmpty => items.isEmpty;

  ListLoaded<T> copyWith({List<T>? items}) {
    return ListLoaded<T>(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}

base class ListError<T> extends BaseListState<T> {
  final AppError error;
  final List<T>? previousItems;

  const ListError({required this.error, this.previousItems});

  bool get canRecover => previousItems != null;

  @override
  List<Object?> get props => [error, previousItems];
}
