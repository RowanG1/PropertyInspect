import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:property_inspect/domain/repository/analytics_repo.dart';

class AnalyticsFirebaseRepo implements AnalyticsRepo {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  sendEvent(String type, Map<String, dynamic> content) {
    analytics.logEvent(name: type, parameters: content);
  }
}
