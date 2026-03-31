import 'analytics_data.dart';

abstract class FirebaseAnalyticsEvent {
  final Map<String, Object>? params;

  FirebaseAnalyticsEvent({Map<String, Object>? params}) : params = params ?? {};

  String get name;

  void addData(AnalyticsData data) => params?.addAll(data.params);
}
