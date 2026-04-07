import '../i_db_raw_command_builder.dart';

/// Builds a `CREATE TABLE IF NOT EXISTS` SQL command from a table definition.
class CreateTableCommandBuilder extends IDbRawCommandBuilder {
  const CreateTableCommandBuilder(super.table);

  @override
  String get command => '''
      CREATE TABLE IF NOT EXISTS ${table.name} ${table.colIdentifier}
    ''';
}
