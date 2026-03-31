import 'dart:async';

import '../i_notifier_service.dart';
import '../objects/notifier_data.dart';

class NotifierService implements INotifierService {
  final _streamController = StreamController<NotifierData>.broadcast();

  @override
  Stream<NotifierData> get stream => _streamController.stream;

  @override
  void notify<T>({required String key, T? data, Type? source}) {
    _streamController.add(NotifierData<T>(key, data, source));
  }

  @override
  Stream<NotifierData> listen(String key) {
    return _streamController.stream.where((event) => event.key == key);
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
