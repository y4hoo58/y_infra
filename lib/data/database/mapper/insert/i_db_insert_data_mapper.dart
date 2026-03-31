import 'i_db_data_mapper.dart';

abstract class IDbInsertDataMapper extends IDbDataMapper {
  const IDbInsertDataMapper();

  Map<String, dynamic> get values;
}
