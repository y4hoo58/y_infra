import '../../../mapper/insert/i_db_insert_data_raw_mapper.dart';
import '../i_db_raw_command_builder.dart';

/// Builds a raw `INSERT INTO` SQL command using a table definition and a raw mapper.
class InsertCommandBuilder extends IDbRawCommandBuilder {
  final IDbInsertDataRawMapper mapper;

  const InsertCommandBuilder(super.table, this.mapper);

  @override
  String get command => '''
      INSERT INTO ${table.name} ${table.colIdentifierForInsert}
      VALUES ${mapper.values}
    ''';
}
