abstract class ILocalStorage {
  Future<bool> save<T>(String key, T value);
  Future<T?> get<T>(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
  Future<bool> containsKey(String key);
}
