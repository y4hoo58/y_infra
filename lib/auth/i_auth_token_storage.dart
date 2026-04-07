import 'objects/token_pair.dart';

/// Interface for persisting and retrieving authentication token pairs.
abstract class IAuthTokenStorage {
  Future<bool> saveTokenPair(TokenPair tokenPair);
  Future<TokenPair?> getTokenPair();
  Future<bool> clearTokens();
  Future<bool> hasToken();
}
