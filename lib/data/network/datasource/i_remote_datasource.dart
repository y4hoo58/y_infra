import 'package:dio/dio.dart';

import '../../../auth/i_auth_token_storage.dart';

/// Base class for remote data sources that execute plain or
/// authenticated HTTP requests via [Dio].
abstract class IRemoteDatasource {
  final IAuthTokenStorage authTokenStorage;
  final Dio dio;

  const IRemoteDatasource(this.authTokenStorage, this.dio);

  Future<T> doRequest<T>(Future<T> Function() request) {
    return request();
  }

  Future<T> doAuthorisedRequest<T>(Future<T> Function(String?) request) async {
    final tokenPair = await authTokenStorage.getTokenPair();
    return request(tokenPair?.accessToken);
  }

  Options createAuthOptions(String? token) {
    if (token != null && token.isNotEmpty) {
      return Options(headers: {'Authorization': 'Bearer $token'});
    }
    return Options();
  }
}
