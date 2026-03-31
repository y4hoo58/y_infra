import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

import '../../converter/i_file_converter.dart';
import '../../path/i_path_provider.dart';
import '../i_file_controller.dart';

class JsonFileController extends IFileController {
  const JsonFileController();

  @override
  Future<File> createFile(IPathProvider pathProvider) async {
    return File(await pathProvider.path);
  }

  @override
  Future load(String path, {bool fromAssets = true}) async {
    final String rawString;
    if (fromAssets) {
      rawString = await rootBundle.loadString(path);
    } else {
      final file = File(path);

      if (!(await file.exists())) {
        throw Exception("File not found");
      }

      rawString = await file.readAsString();
    }

    return json.decode(rawString);
  }

  @override
  Future<void> save(IPathProvider pathProvider, IFileConverter data) async {
    final file = File(await pathProvider.path);
    await file.writeAsString(json.encode(data.converted));
  }

  @override
  Future<void> saveWithFile(File file, IFileConverter data) {
    return file.writeAsString(json.encode(data.converted));
  }
}
