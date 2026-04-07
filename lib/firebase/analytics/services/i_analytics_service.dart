import 'package:firebase_analytics/firebase_analytics.dart';

import '../objects/analytics_event.dart';
import '../objects/user_property.dart';

/// Interface for logging Firebase Analytics events and setting user properties.
abstract class IFirebaseAnalyticsService {
  FirebaseAnalytics get analyticsInstance => FirebaseAnalytics.instance;

  late final observer = FirebaseAnalyticsObserver(analytics: analyticsInstance);

  void init();
  void logEvent(FirebaseAnalyticsEvent event);
  void setUserProperty(UserProperty property);
}
