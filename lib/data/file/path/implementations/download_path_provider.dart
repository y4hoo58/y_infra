import 'package:path_provider/path_provider.dart';

import '../i_path_provider.dart';

/// Resolves file paths within the platform's downloads directory.
final class DownloadPathProvider extends IPathProvider {
  const DownloadPathProvider(super.fileName);

  @override
  Future<String> get path async {
    final directory = await getDownloadsDirectory();

    if (directory == null) throw Exception('Downloads directory not found');

    return '${directory.path}/$fileName';
  }
}
