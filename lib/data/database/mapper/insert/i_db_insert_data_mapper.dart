import 'i_db_data_mapper.dart';

/// Mapper that converts domain data into a column-value map for database insertion.
abstract class IDbInsertDataMapper extends IDbDataMapper {
  const IDbInsertDataMapper();

  Map<String, dynamic> get values;
}
