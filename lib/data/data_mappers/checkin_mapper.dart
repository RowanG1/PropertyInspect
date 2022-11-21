class CheckinMapper {
  Map<String, dynamic> toJson(String visitorId, String propertyId) {
    return <String, dynamic>{'visitorId': visitorId, 'propertyId': propertyId};
  }
}
