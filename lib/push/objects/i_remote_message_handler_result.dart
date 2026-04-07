/// Typed result of handling a remote message, containing an id and parsed data.
abstract class IRemoteMessageHandlerResult<T> {
  final int id;
  final T data;

  const IRemoteMessageHandlerResult(this.id, this.data);
}
