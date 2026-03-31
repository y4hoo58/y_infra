import '../insert/i_db_data_mapper.dart';

abstract class IDbUpdateDataMapper extends IDbDataMapper {
  final int index;
  const IDbUpdateDataMapper(this.index);

  Map<String, dynamic> get values;
}
