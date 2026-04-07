import '../../objects/i_database_table.dart';

/// Base class for builders that produce raw SQL command strings
/// for a given database table.
abstract class IDbRawCommandBuilder {
  final IDatabaseTable table;

  const IDbRawCommandBuilder(this.table);

  String get command;
}
