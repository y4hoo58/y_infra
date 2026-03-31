import 'objects/cache_type.dart';

abstract class ICache {
  void set<T>(String key, T data, {CacheType type = CacheType.global, Duration? ttl});
  T? get<T>(String key);
  void remove(String key);
  void removeByPrefix(String prefix);
  void removeAllType(CacheType type);
  void clear();
}
