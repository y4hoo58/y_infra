import 'cache_type.dart';

/// A typed cache entry that holds data along with its [CacheType], creation
/// timestamp, and optional TTL for expiration.
class CacheData<T> {
  final CacheType type;
  final T data;
  final DateTime createdAt;
  final Duration? ttl;

  CacheData(this.type, this.data, {this.ttl}) : createdAt = DateTime.now();

  bool get isExpired => ttl != null && DateTime.now().difference(createdAt) > ttl!;
}
