import '../i_file_converter.dart';

final class MapListFileConverter extends IFileConverter<List<Map>, List<Map>> {
  const MapListFileConverter(super.data);

  @override
  List<Map> get converted => data.map((e) => e).toList();
}
