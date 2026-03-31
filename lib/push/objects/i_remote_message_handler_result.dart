abstract class IRemoteMessageHandlerResult<T> {
  final int id;
  final T data;

  const IRemoteMessageHandlerResult(this.id, this.data);
}
