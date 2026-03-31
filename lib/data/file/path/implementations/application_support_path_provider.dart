import 'package:path_provider/path_provider.dart';

import '../i_path_provider.dart';

final class ApplicationSupportPathProvider extends IPathProvider {
  const ApplicationSupportPathProvider(super.fileName);

  @override
  Future<String> get path async {
    final directory = await getApplicationSupportDirectory();

    return '${directory.path}/$fileName';
  }
}
