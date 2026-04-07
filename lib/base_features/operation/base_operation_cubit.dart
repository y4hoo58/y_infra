import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/error_mapper.dart';
import 'base_operation_state.dart';

/// Base cubit for single async operations (create, update, delete, toggle, etc.).
///
/// ```dart
/// class DeleteItemCubit extends BaseOperationCubit {
///   final ItemRepository _repo;
///   DeleteItemCubit(this._repo);
///
///   Future<void> delete(int id) => execute(
///     targetId: id,
///     operation: () => _repo.delete(id),
///   );
/// }
/// ```
abstract class BaseOperationCubit<TResult>
    extends Cubit<BaseOperationState> {
  BaseOperationCubit() : super(const OperationInitial());

  /// Runs [operation] with automatic loading, success, and error state handling.
  /// Ignores the call if an operation is already in progress.
  Future<void> execute({
    required Future<TResult> Function() operation,
    int? targetId,
  }) async {
    if (state is OperationInProgress) return;
    emit(OperationInProgress(targetId: targetId));
    try {
      final result = await operation();
      if (isClosed) return;
      emit(OperationSuccess<TResult>(targetId: targetId, result: result));
    } catch (e, stack) {
      if (isClosed) return;
      emit(OperationFailure(
        targetId: targetId,
        error: ErrorMapper.map(e, stack),
      ));
    }
  }

  void reset() {
    if (!isClosed) emit(const OperationInitial());
  }
}
