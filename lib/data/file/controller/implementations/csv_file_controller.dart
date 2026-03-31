import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../converter/i_file_converter.dart';
import '../../path/i_path_provider.dart';
import '../i_file_controller.dart';

class CsvFileController extends IFileController {
  const CsvFileController();

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

    return const CsvToListConverter().convert(rawString);
  }

  @override
  Future<void> saveWithFile(File file, IFileConverter data) {
    return file.writeAsString(
      const ListToCsvConverter().convert(data.converted),
    );
  }

  @override
  Future<void> save(IPathProvider pathProvider, IFileConverter data) async {
    final file = await createFile(pathProvider);

    await file.writeAsString(
      const ListToCsvConverter().convert(data.converted),
    );
  }
}
