import 'package:equatable/equatable.dart';

import '../../core/errors/app_error.dart';

/// Base state hierarchy for single async operations (initial, in-progress, success, failure).
abstract class BaseOperationState<Id> extends Equatable {
  const BaseOperationState();

  @override
  List<Object?> get props => [];
}

base class OperationInitial<Id> extends BaseOperationState<Id> {
  const OperationInitial();
}

base class OperationInProgress<Id> extends BaseOperationState<Id> {
  final Id? targetId;

  const OperationInProgress({this.targetId});

  @override
  List<Object?> get props => [targetId];
}

base class OperationSuccess<TResult, Id> extends BaseOperationState<Id> {
  final Id? targetId;
  final TResult? result;

  const OperationSuccess({this.targetId, this.result});

  @override
  List<Object?> get props => [targetId, result];
}

base class OperationFailure<Id> extends BaseOperationState<Id> {
  final Id? targetId;
  final AppError error;

  const OperationFailure({this.targetId, required this.error});

  @override
  List<Object?> get props => [targetId, error];
}
