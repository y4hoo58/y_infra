import 'objects/cache_type.dart';

/// Interface for an in-memory cache supporting typed storage, TTL, and
/// removal by key, prefix, or [CacheType].
abstract class ICache {
  void set<T>(String key, T data, {CacheType type = CacheType.global, Duration? ttl});
  T? get<T>(String key);
  void remove(String key);
  void removeByPrefix(String prefix);
  void removeAllType(CacheType type);
  void clear();
}
