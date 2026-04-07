/// Converts data of type [D] into a file-serializable format of type [C].
abstract class IFileConverter<D, C> {
  final D data;

  const IFileConverter(this.data);

  C get converted;
}
