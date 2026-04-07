import 'objects/notifier_data.dart';

/// Interface for a lightweight pub/sub notification service using streams.
abstract class INotifierService {
  Stream<NotifierData> get stream;
  void notify<T>({required String key, T? data, Type? source});
  Stream<NotifierData> listen(String key);
  void dispose();
}
