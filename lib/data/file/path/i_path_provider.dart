abstract class IPathProvider {
  final String fileName;

  const IPathProvider(this.fileName);

  Future<String> get path;
}
