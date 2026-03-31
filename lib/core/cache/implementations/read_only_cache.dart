import '../i_cache.dart';
import '../objects/cache_type.dart';

class ReadOnlyCache implements ICache {
  final ICache _delegate;

  ReadOnlyCache(this._delegate);

  @override
  T? get<T>(String key) => _delegate.get<T>(key);

  @override
  void set<T>(String key, T data, {CacheType type = CacheType.global, Duration? ttl}) {}

  @override
  void remove(String key) {}

  @override
  void removeByPrefix(String prefix) {}

  @override
  void removeAllType(CacheType type) {}

  @override
  void clear() {}
}
