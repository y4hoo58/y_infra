import '../../core/storage/i_local_storage.dart';
import '../i_auth_token_storage.dart';
import '../objects/token_pair.dart';

/// Stores and retrieves access/refresh tokens using local storage.
class AuthTokenStorage implements IAuthTokenStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  final ILocalStorage _storage;

  AuthTokenStorage(this._storage);

  @override
  Future<bool> saveTokenPair(TokenPair tokenPair) async {
    final a = await _storage.save<String>(_accessTokenKey, tokenPair.accessToken);
    final b = await _storage.save<String>(_refreshTokenKey, tokenPair.refreshToken);
    return a && b;
  }

  @override
  Future<TokenPair?> getTokenPair() async {
    final access = await _storage.get<String>(_accessTokenKey);
    final refresh = await _storage.get<String>(_refreshTokenKey);
    if (access == null || refresh == null) return null;
    return TokenPair(accessToken: access, refreshToken: refresh);
  }

  @override
  Future<bool> clearTokens() async {
    final a = await _storage.remove(_accessTokenKey);
    final b = await _storage.remove(_refreshTokenKey);
    return a || b;
  }

  @override
  Future<bool> hasToken() async {
    return await _storage.containsKey(_accessTokenKey);
  }
}
