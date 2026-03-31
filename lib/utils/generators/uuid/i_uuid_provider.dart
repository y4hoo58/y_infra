abstract class IUuidProvider {
  final String localStorageKey;

  const IUuidProvider(this.localStorageKey);

  Future<String> provide();
}
