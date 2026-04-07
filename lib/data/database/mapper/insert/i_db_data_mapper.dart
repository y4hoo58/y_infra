/// Base interface for all database data mappers, providing a unique key identifier.
abstract class IDbDataMapper {
  const IDbDataMapper();

  String get key;
}
