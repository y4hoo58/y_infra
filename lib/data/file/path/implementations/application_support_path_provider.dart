import 'package:path_provider/path_provider.dart';

import '../i_path_provider.dart';

/// Resolves file paths within the platform's application support directory.
final class ApplicationSupportPathProvider extends IPathProvider {
  const ApplicationSupportPathProvider(super.fileName);

  @override
  Future<String> get path async {
    final directory = await getApplicationSupportDirectory();

    return '${directory.path}/$fileName';
  }
}
