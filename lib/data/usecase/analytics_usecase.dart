import 'package:property_inspect/domain/repository/analytics.dart';

class AnalyticsUseCase {
  final Analytics _analytics;

  AnalyticsUseCase(this._analytics);

  execute(String type, Map<String, dynamic> content) {
    return _analytics.sendEvent(type, content);
  }
}
