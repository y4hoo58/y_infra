import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_operation_state.dart';

abstract class BaseOperationCubit extends Cubit<BaseOperationState> {
  BaseOperationCubit() : super(const OperationInitial());

  void reset() {
    if (!isClosed) emit(const OperationInitial());
  }
}
