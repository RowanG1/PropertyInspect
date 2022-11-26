import 'package:property_inspect/domain/repository/analytics_repo.dart';

class AnalyticsUseCase {
  final AnalyticsRepo _analytics;

  AnalyticsUseCase(this._analytics);

  execute(String type, Map<String, dynamic> content) {
    return _analytics.sendEvent(type, content);
  }
}
