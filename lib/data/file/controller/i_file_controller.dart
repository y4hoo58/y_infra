import 'dart:io';

import '../path/i_path_provider.dart';
import '../converter/i_file_converter.dart';

abstract class IFileController {
  const IFileController();

  Future<File> createFile(IPathProvider pathProvider);
  Future load(String path, {bool fromAssets = true});
  Future<void> save(IPathProvider pathProvider, IFileConverter data);
  Future<void> saveWithFile(File file, IFileConverter data);
}
