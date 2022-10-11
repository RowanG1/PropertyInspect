import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:property_inspect/domain/repository/analytics.dart';

class AnalyticsFirebaseRepo implements Analytics {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  sendEvent(String type, Map<String, dynamic> content) {
    print("Sent event to firebase");
    analytics.logEvent(name: type, parameters: content);
  }
}
