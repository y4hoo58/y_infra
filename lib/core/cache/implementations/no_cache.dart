import '../i_cache.dart';
import '../objects/cache_type.dart';

class NoCache implements ICache {
  @override
  T? get<T>(String key) => null;

  @override
  void set<T>(String key, T data, {CacheType type = CacheType.global}) {}

  @override
  void remove(String key) {}

  @override
  void removeByPrefix(String prefix) {}

  @override
  void removeAllType(CacheType type) {}

  @override
  void clear() {}
}
