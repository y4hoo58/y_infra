/// Describes a database table by its name and column definitions,
/// and provides formatted column identifiers for SQL statements.
abstract class IDatabaseTable {
  final String name;

  const IDatabaseTable(this.name);

  Map<String, String> get columns;

  String get colIdentifier {
    final cols = columns.entries.map((e) => '${e.key} ${e.value}').join(', ');
    return '($cols)';
  }

  String get colIdentifierForInsert {
    final cols = columns.keys.join(', ');
    return '($cols)';
  }
}
