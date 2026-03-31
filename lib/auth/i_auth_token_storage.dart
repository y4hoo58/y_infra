import 'token_pair.dart';

abstract class IAuthTokenStorage {
  Future<bool> saveTokenPair(TokenPair tokenPair);
  Future<TokenPair?> getTokenPair();
  Future<bool> clearTokens();
  Future<bool> hasToken();
}
