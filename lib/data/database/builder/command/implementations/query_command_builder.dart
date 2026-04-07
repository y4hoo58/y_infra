import '../../query/i_query_builder.dart';
import '../i_db_raw_command_builder.dart';

/// Builds a raw `SELECT *` SQL command with query clauses from an [IQueryBuilder].
class QueryCommandBuilder extends IDbRawCommandBuilder {
  final IQueryBuilder builder;

  const QueryCommandBuilder(super.table, this.builder);

  @override
  String get command => '''
      SELECT * FROM ${table.name} ${builder.query}
    ''';
}
