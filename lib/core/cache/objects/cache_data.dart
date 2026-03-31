import 'cache_type.dart';

class CacheData<T> {
  final CacheType type;
  final T data;
  final DateTime createdAt;
  final Duration? ttl;

  CacheData(this.type, this.data, {this.ttl}) : createdAt = DateTime.now();

  bool get isExpired => ttl != null && DateTime.now().difference(createdAt) > ttl!;
}
