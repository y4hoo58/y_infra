import '../i_cache.dart';
import '../objects/cache_type.dart';

class WriteOnlyCache implements ICache {
  final ICache _delegate;

  WriteOnlyCache(this._delegate);

  @override
  T? get<T>(String key) => null;

  @override
  void set<T>(String key, T data, {CacheType type = CacheType.global, Duration? ttl}) {
    _delegate.set<T>(key, data, type: type, ttl: ttl);
  }

  @override
  void remove(String key) => _delegate.remove(key);

  @override
  void removeByPrefix(String prefix) => _delegate.removeByPrefix(prefix);

  @override
  void removeAllType(CacheType type) => _delegate.removeAllType(type);

  @override
  void clear() => _delegate.clear();
}
