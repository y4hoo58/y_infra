import '../core/cache/i_cache.dart';
import '../core/cache/objects/cache_type.dart';
import '../core/notifier/i_notifier_service.dart';

class _QueueEntry<T> {
  final Future<T> future;
  int refCount;

  _QueueEntry(this.future) : refCount = 1;
}

abstract class IRepository {
  final INotifierService notifierService;

  IRepository(this.notifierService);

  static final Map<String, _QueueEntry> _queueCache = {};

  Future<T> queue<T>(
    String key,
    Future<T> Function() callback, {
    Type? source,
    ICache? cache,
    CacheType? cacheType,
    List<String>? invalidateKeys,
    String? invalidatePrefix,
    CacheType? invalidateCacheType,
  }) async {
    final cachedData = cache?.get<T>(key);
    if (cachedData != null) return cachedData;

    if (_queueCache.containsKey(key)) {
      final entry = _queueCache[key];

      if (entry != null) {
        entry.refCount++;

        try {
          return await entry.future as T;
        } finally {
          entry.refCount--;
          if (entry.refCount == 0) _queueCache.remove(key);
        }
      }
    }

    final future = callback();
    final entry = _QueueEntry<T>(future);
    _queueCache[key] = entry;

    try {
      final result = await future;

      notifierService.notify<T>(key: key, data: result, source: source);

      if (cacheType != null) {
        cache?.set<T>(key, result, type: cacheType);
      }

      if (cache != null && invalidateKeys != null) {
        for (final k in invalidateKeys) {
          cache.remove(k);
        }
      }

      if (cache != null && invalidatePrefix != null) {
        cache.removeByPrefix(invalidatePrefix);
      }

      if (cache != null && invalidateCacheType != null) {
        cache.removeAllType(invalidateCacheType);
      }

      return result;
    } finally {
      entry.refCount--;
      if (entry.refCount == 0) _queueCache.remove(key);
    }
  }
}
