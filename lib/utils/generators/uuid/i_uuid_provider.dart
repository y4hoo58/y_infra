/// Interface for generating or retrieving a persisted UUID.
abstract class IUuidProvider {
  final String localStorageKey;

  const IUuidProvider(this.localStorageKey);

  Future<String> provide();
}
