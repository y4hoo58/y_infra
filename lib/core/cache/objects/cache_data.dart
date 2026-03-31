import 'cache_type.dart';

class CacheData<T> {
  final CacheType type;
  final T data;

  const CacheData(this.type, this.data);
}
