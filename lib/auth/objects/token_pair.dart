import 'package:equatable/equatable.dart';

/// Holds an access token and refresh token pair.
class TokenPair extends Equatable {
  final String accessToken;
  final String refreshToken;

  const TokenPair({required this.accessToken, required this.refreshToken});

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
