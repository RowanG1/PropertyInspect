abstract class AnalyticsRepo {
  void sendEvent(String type, Map<String, dynamic> content);
}
