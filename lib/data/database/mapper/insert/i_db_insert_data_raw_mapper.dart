import 'i_db_data_mapper.dart';

/// Mapper that converts domain data into a raw SQL values string for insertion.
abstract class IDbInsertDataRawMapper extends IDbDataMapper {
  const IDbInsertDataRawMapper();

  String get values;
}
