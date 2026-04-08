import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/error_mapper.dart';
import 'base_operation_state.dart';

/// Base cubit for single async operations (create, update, delete, toggle, etc.).
///
/// ```dart
/// class DeleteItemCubit extends BaseOperationCubit<void, int> {
///   final ItemRepository _repo;
///   DeleteItemCubit(this._repo);
///
///   Future<void> delete(int id) => execute(
///     targetId: id,
///     operation: () => _repo.delete(id),
///   );
/// }
/// ```
abstract class BaseOperationCubit<TResult, Id>
    extends Cubit<BaseOperationState<Id>> {
  BaseOperationCubit() : super(OperationInitial<Id>());

  /// Runs [operation] with automatic loading, success, and error state handling.
  /// Ignores the call if an operation is already in progress.
  Future<void> execute({
    required Future<TResult> Function() operation,
    Id? targetId,
  }) async {
    if (state is OperationInProgress<Id>) return;
    emit(OperationInProgress<Id>(targetId: targetId));
    try {
      final result = await operation();
      if (isClosed) return;
      emit(OperationSuccess<TResult, Id>(targetId: targetId, result: result));
    } catch (e, stack) {
      if (isClosed) return;
      emit(OperationFailure<Id>(
        targetId: targetId,
        error: ErrorMapper.map(e, stack),
      ));
    }
  }

  void reset() {
    if (!isClosed) emit(OperationInitial<Id>());
  }
}
