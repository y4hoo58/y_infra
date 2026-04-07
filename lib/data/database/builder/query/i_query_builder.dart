/// Interface for building the query clause portion of a SQL statement.
abstract class IQueryBuilder {
  const IQueryBuilder();

  String get query;
}
