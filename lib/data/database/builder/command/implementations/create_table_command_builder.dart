import '../i_db_raw_command_builder.dart';

class CreateTableCommandBuilder extends IDbRawCommandBuilder {
  const CreateTableCommandBuilder(super.table);

  @override
  String get command => '''
      CREATE TABLE IF NOT EXISTS ${table.name} ${table.colIdentifier}
    ''';
}
