class NotifierData<T> {
  final String key;
  final T? data;
  final Type? source;

  const NotifierData(this.key, this.data, [this.source]);
}
