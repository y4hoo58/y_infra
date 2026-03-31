abstract class IFileConverter<D, C> {
  final D data;

  const IFileConverter(this.data);

  C get converted;
}
