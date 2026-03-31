import 'package:firebase_analytics/firebase_analytics.dart';

import '../objects/analytics_event.dart';
import '../objects/user_property.dart';

abstract class IFirebaseAnalyticsService {
  FirebaseAnalytics get analyticsInstance => FirebaseAnalytics.instance;

  late final observer = FirebaseAnalyticsObserver(analytics: analyticsInstance);

  void init();
  void logEvent(FirebaseAnalyticsEvent event);
  void setUserProperty(UserProperty property);
}
