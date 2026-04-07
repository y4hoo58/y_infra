/// Base class for structured analytics event parameters.
abstract class AnalyticsData {
  const AnalyticsData();

  Map<String, Object> get params;
}
