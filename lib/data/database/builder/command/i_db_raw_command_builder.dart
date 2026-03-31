import '../../objects/i_database_table.dart';

abstract class IDbRawCommandBuilder {
  final IDatabaseTable table;

  const IDbRawCommandBuilder(this.table);

  String get command;
}
