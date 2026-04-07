import '../insert/i_db_data_mapper.dart';

/// Mapper that provides a column-value map and row index for database updates.
abstract class IDbUpdateDataMapper extends IDbDataMapper {
  final int index;
  const IDbUpdateDataMapper(this.index);

  Map<String, dynamic> get values;
}
