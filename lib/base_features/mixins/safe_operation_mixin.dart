import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/app_error.dart';
import '../../core/errors/error_mapper.dart';

mixin SafeOperationMixin<TState> on Cubit<TState> {
  Future<void> safeExecute<T>({
    required TState loadingState,
    required Future<T> Function() operation,
    required TState Function(T result) onSuccess,
    required TState Function(AppError error) onError,
    TState Function()? onEmpty,
    bool Function(T result)? isEmpty,
  }) async {
    emit(loadingState);
    try {
      final result = await operation();
      if (isClosed) return;

      if (isEmpty != null && onEmpty != null && isEmpty(result)) {
        emit(onEmpty());
      } else {
        emit(onSuccess(result));
      }
    } catch (e, stack) {
      if (isClosed) return;
      emit(onError(ErrorMapper.map(e, stack)));
    }
  }
}
