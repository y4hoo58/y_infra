/// Provides a full file path by combining a platform directory with a file name.
abstract class IPathProvider {
  final String fileName;

  const IPathProvider(this.fileName);

  Future<String> get path;
}
