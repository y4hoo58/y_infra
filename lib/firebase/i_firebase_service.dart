import 'package:firebase_core/firebase_core.dart';

import 'analytics/services/i_analytics_service.dart';
import 'messaging/services/i_messaging_service.dart';
import 'realtime_database/services/i_realtime_database_service.dart';

/// Aggregates Firebase sub-services (analytics, messaging, realtime DB) and handles initialization.
abstract class IFirebaseService {
  final IFirebaseAnalyticsService? analytics;
  final IFirebaseMessagingService? messaging;
  final IFirebaseRealtimeDatabaseService? realTimeDb;

  const IFirebaseService({this.analytics, this.messaging, this.realTimeDb});

  static Future<void> initApp() => Firebase.initializeApp();

  void initServices() {
    analytics?.init();
    messaging?.init();
    realTimeDb?.init();
  }
}
