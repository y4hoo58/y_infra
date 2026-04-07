import 'package:equatable/equatable.dart';

import '../enums/unauthenticated_reason.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

base class AuthInitial extends AuthState {
  const AuthInitial();
}

base class AuthLoading extends AuthState {
  const AuthLoading();
}

base class Authenticated extends AuthState {
  const Authenticated();
}

base class Unauthenticated extends AuthState {
  final UnauthenticatedReason? reason;

  const Unauthenticated({this.reason});

  @override
  List<Object?> get props => [reason];
}
