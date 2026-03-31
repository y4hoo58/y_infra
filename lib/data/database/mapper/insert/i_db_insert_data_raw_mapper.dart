import 'i_db_data_mapper.dart';

abstract class IDbInsertDataRawMapper extends IDbDataMapper {
  const IDbInsertDataRawMapper();

  String get values;
}
