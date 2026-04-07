import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/notifier/i_notifier_service.dart';
import '../i_auth_token_storage.dart';
import '../objects/token_pair.dart';
import 'auth_state.dart';
import '../enums/unauthenticated_reason.dart';

/// A base auth cubit that manages authentication state.
///
/// Handles token persistence, auth state transitions, and listens for
/// auth failure events via [INotifierService] (e.g. from [AuthInterceptor]).
///
/// This cubit does NOT handle login — that's project-specific.
/// Instead, call [onAuthenticated] after a successful login:
///
/// ```dart
/// // In your login cubit or wherever login happens:
/// final tokens = await api.login(email, password);
/// authCubit.onAuthenticated(tokens);
/// ```
///
/// To listen for auth failures from the network layer:
///
/// ```dart
/// AuthCubit(
///   tokenStorage: tokenStorage,
///   notifier: notifierService,
///   authFailureKey: 'auth_failure', // must match what AuthInterceptor notifies
/// );
/// ```
class AuthCubit extends Cubit<AuthState> {
  final IAuthTokenStorage _tokenStorage;
  final INotifierService? _notifier;
  final String _authFailureKey;

  StreamSubscription? _notifierSubscription;

  AuthCubit({
    required IAuthTokenStorage tokenStorage,
    INotifierService? notifier,
    String authFailureKey = 'auth_failure',
  })  : _tokenStorage = tokenStorage,
        _notifier = notifier,
        _authFailureKey = authFailureKey,
        super(const AuthInitial()) {
    _listenForAuthFailures();
  }

  /// Checks stored tokens and emits [Authenticated] or [Unauthenticated].
  /// Call this on app startup.
  Future<void> checkAuth() async {
    emit(const AuthLoading());

    final hasToken = await _tokenStorage.hasToken();
    if (hasToken) {
      emit(const Authenticated());
    } else {
      emit(const Unauthenticated(reason: UnauthenticatedReason.noToken));
    }
  }

  /// Saves the token pair and emits [Authenticated].
  /// Call this after a successful login.
  Future<void> onAuthenticated(TokenPair tokens) async {
    await _tokenStorage.saveTokenPair(tokens);
    emit(const Authenticated());
  }

  /// Clears tokens and emits [Unauthenticated].
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
    emit(const Unauthenticated(reason: UnauthenticatedReason.loggedOut));
  }

  void _listenForAuthFailures() {
    _notifierSubscription = _notifier?.listen(_authFailureKey).listen((_) {
      _onAuthFailure();
    });
  }

  Future<void> _onAuthFailure() async {
    await _tokenStorage.clearTokens();
    emit(const Unauthenticated(reason: UnauthenticatedReason.sessionExpired));
  }

  @override
  Future<void> close() {
    _notifierSubscription?.cancel();
    return super.close();
  }
}
