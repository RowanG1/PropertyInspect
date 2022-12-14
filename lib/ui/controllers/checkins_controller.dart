import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:property_inspect/application/usecase/get_checkins_for_listing_use_case.dart';
import '../../data/types/optional.dart';
import '../../data/types/state.dart' as s;
import '../../domain/entities/visitor.dart';
import '../../application/usecase/get_login_id_use_case.dart';
import 'package:rxdart/rxdart.dart' as rx_raw;

class CheckinsController extends GetxController {
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final Rx<Optional<String>> _listingId = Optional<String>(null).obs;
  final GetLoginIdUseCase _getLoginIdUseCase;
  final GetCheckinsForListingUseCase _checkinsForListingUseCase;
  final Rx<s.State<List<Visitor>>> _checkedInVisitors = s.State<List<Visitor>>().obs;
final Rx<CheckInsLumpedInputData> _checkInsLumpedInput = CheckInsLumpedInputData().obs;
  CheckinsController(this._getLoginIdUseCase, this._checkinsForListingUseCase);
  final Logger _logger = Get.find();
  Worker? _checkinsLumpedInputSubscription;

  @override
  void onInit() {
    super.onInit();
    _userId.bindStream(_getLoginIdUseCase.execute());

    final lumpedStream = rx_raw.Rx.combineLatest2(_userId.stream, _listingId.stream,
            (a, b)
    => CheckInsLumpedInputData(userId: a.value, listingId: b.value));

    _checkInsLumpedInput.bindStream(lumpedStream);

    _checkinsLumpedInputSubscription = ever(_checkInsLumpedInput, (value) {
      final userId = value.userId;
      final listingId = value.listingId;

      if (userId != null && listingId != null) {
        final visitorStream =
            _checkinsForListingUseCase.execute(userId, listingId);
        final mappedVisitorStream = visitorStream
            .map((event) => s.State(content: event))
            .handleError((onError) {
          _checkedInVisitors.value = s.State<List<Visitor>>(error: onError);
        });
        _checkedInVisitors.bindStream(mappedVisitorStream);
      }
    });
  }

  Rx<s.State<List<Visitor>>> getCheckinsRx() {
    return _checkedInVisitors;
  }

  List<Visitor> getCheckins() {
    return _checkedInVisitors.value.content ?? [];
  }

  setPropertyId(String? propertyId) {
    _listingId.value = Optional(propertyId);
  }

  isLoading() {
    return _checkedInVisitors.value.loading;
  }

  @override
  void dispose() {
    try {
      _checkedInVisitors.close();
      _checkinsLumpedInputSubscription?.dispose();
    } catch(e) {
      _logger.d('Error on dispose streams', e);
    }
    super.dispose();
  }
}

class CheckInsLumpedInputData {
  String? userId;
  String? listingId;

  CheckInsLumpedInputData({this.listingId, this.userId});
}
