import 'package:equatable/equatable.dart';

import '../../core/errors/app_error.dart';

sealed class BaseOperationState extends Equatable {
  const BaseOperationState();

  @override
  List<Object?> get props => [];
}

base class OperationInitial extends BaseOperationState {
  const OperationInitial();
}

base class OperationInProgress extends BaseOperationState {
  final int? targetId;

  const OperationInProgress({this.targetId});

  @override
  List<Object?> get props => [targetId];
}

base class OperationSuccess<TResult> extends BaseOperationState {
  final int? targetId;
  final TResult? result;

  const OperationSuccess({this.targetId, this.result});

  @override
  List<Object?> get props => [targetId, result];
}

base class OperationFailure extends BaseOperationState {
  final int? targetId;
  final AppError error;

  const OperationFailure({this.targetId, required this.error});

  @override
  List<Object?> get props => [targetId, error];
}
