/// Payload for a notification event, identified by [key] with optional typed
/// [data] and [source].
class NotifierData<T> {
  final String key;
  final T? data;
  final Type? source;

  const NotifierData(this.key, this.data, [this.source]);
}
