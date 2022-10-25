import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:property_inspect/domain/usecase/get_checkins_for_listing_use_case.dart';
import '../../data/types/optional.dart';
import '../../domain/entities/state.dart';
import '../../domain/entities/visitor.dart';
import '../../domain/usecase/get_login_id_use_case.dart';
import 'package:rxdart/rxdart.dart' as RxRaw;

class CheckinsController extends GetxController {
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final Rx<Optional<String>> _listingId = Optional<String>(null).obs;
  GetLoginIdUseCase _getLoginIdUseCase;
  GetCheckinsForListingUseCase _checkinsForListingUseCase;
  Rx<State<List<Visitor>>> _checkedInVisitors = State<List<Visitor>>().obs;
Rx<CheckInsLumpedInputData> _checkInsLumpedInput = CheckInsLumpedInputData().obs;
  CheckinsController(this._getLoginIdUseCase, this._checkinsForListingUseCase);

  @override
  void onInit() {
    super.onInit();
    _userId.bindStream(_getLoginIdUseCase.execute());

    final lumpedStream = RxRaw.Rx.combineLatest2(_userId.stream, _listingId.stream,
            (a, b)
    => CheckInsLumpedInputData(userId: a.value, listingId: b.value));

    _checkInsLumpedInput.bindStream(lumpedStream);

    ever(_checkInsLumpedInput, (value) {
      final userId = value.userId;
      final listingId = value.listingId;

      print('We got user id update.');
      if (userId != null && listingId != null) {
        print('We have a run.');
        final visitorStream =
            _checkinsForListingUseCase.execute(userId, listingId);
        final mappedVisitorStream = visitorStream
            .map((event) => State(content: event))
            .handleError((onError) {
          _checkedInVisitors.value = State<List<Visitor>>(error: onError);
        });
        _checkedInVisitors.bindStream(mappedVisitorStream);
      }
    });
  }

  List<Visitor> getCheckins() {
    return _checkedInVisitors.value.content ?? [];
  }

  setPropertyId(String? propertyId) {
    print('Setting prop id: $propertyId');
    _listingId.value = Optional(propertyId);
  }

  isLoading() {
    return _checkedInVisitors.value.loading;
  }
}

class CheckInsLumpedInputData {
  String? userId;
  String? listingId;

  CheckInsLumpedInputData({this.listingId, this.userId});
}
