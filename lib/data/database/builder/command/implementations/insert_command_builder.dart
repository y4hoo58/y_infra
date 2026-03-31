import '../../../mapper/insert/i_db_insert_data_raw_mapper.dart';
import '../i_db_raw_command_builder.dart';

class InsertCommandBuilder extends IDbRawCommandBuilder {
  final IDbInsertDataRawMapper mapper;

  const InsertCommandBuilder(super.table, this.mapper);

  @override
  String get command => '''
      INSERT INTO ${table.name} ${table.colIdentifierForInsert}
      VALUES ${mapper.values}
    ''';
}
