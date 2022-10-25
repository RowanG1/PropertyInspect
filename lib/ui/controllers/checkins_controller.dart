import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:property_inspect/domain/usecase/get_checkins_for_listing_use_case.dart';
import '../../data/types/optional.dart';
import '../../domain/entities/state.dart';
import '../../domain/entities/visitor.dart';
import '../../domain/usecase/get_login_id_use_case.dart';

class CheckinsController extends GetxController {
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final String? _listingId;
  GetLoginIdUseCase _getLoginIdUseCase;
  GetCheckinsForListingUseCase _checkinsForListingUseCase;
  String? listingId;
  Rx<State<List<Visitor>>> _checkedInVisitors = State<List<Visitor>>().obs;

  CheckinsController(this._getLoginIdUseCase, this._checkinsForListingUseCase,
      this._listingId);

  @override
  void onInit() {
    super.onInit();
    _userId.bindStream(_getLoginIdUseCase.execute());

    ever(_userId, (value) {
      final userId = value.value;
      if (userId != null && _listingId != null) {
        final visitorStream =
            _checkinsForListingUseCase.execute(userId, _listingId!);
        final mappedVisitorStream = visitorStream
            .map((event) => State(content: event))
            .handleError((onError) {
          _checkedInVisitors.value = State<List<Visitor>>(error: onError);
        });
        _checkedInVisitors.bindStream(mappedVisitorStream);
      }
    });
  }
}
