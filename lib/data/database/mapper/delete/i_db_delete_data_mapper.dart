import '../insert/i_db_data_mapper.dart';

abstract class IDbDeleteDataMapper extends IDbDataMapper {
  final int index;
  const IDbDeleteDataMapper(this.index);

  Map<String, dynamic> get values;
}
