import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:property_inspect/application/usecase/get_is_visitor_registerd_use_case.dart';
import '../../data/types/optional.dart';
import '../../data/types/state.dart' as s;
import '../../application/usecase/get_login_id_use_case.dart';

class VisitorFlowController extends GetxController {
  final Rx<s.State<bool>> _visitorIsRegistered = s.State<bool>().obs;
  final GetLoginIdUseCase _loginIdUseCase;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final GetIsVisitorRegisteredUseCase _isVisitorRegisteredUseCase;
  // ignore: unnecessary_cast
  final Rx<String?> currentPage = (null as String?).obs;
  final Logger _logger = Get.find();
  Worker? _userIdSubscription;

  VisitorFlowController(this._isVisitorRegisteredUseCase, this._loginIdUseCase);

  @override
  void onInit() {
    super.onInit();
    _userId.bindStream(_loginIdUseCase.execute());

    _userIdSubscription = ever(_userId, (id) {
      if (id.value != null) {
        _getIsVisitorRegistered(id.value!);
      }
    });
  }

  _getIsVisitorRegistered(String id) {
    try {
      _visitorIsRegistered.value = s.State<bool>(loading: true);

      final isRegistered = _isVisitorRegisteredUseCase.execute(id);
      final isRegisteredState = isRegistered.map((event) => s.State<bool>(content: event));
      isRegisteredState.handleError((onError) => _visitorIsRegistered.value = s.State<bool>(error: onError));

      _visitorIsRegistered
          .bindStream(isRegisteredState);
    } catch (e) {
      _visitorIsRegistered.value = s.State<bool>(error: Exception("$e"));
    }
  }

  getIsLoading() {
    return _visitorIsRegistered.value.loading;
  }

  bool getIsVisitorRegistered() {
    return _visitorIsRegistered.value.content == true;
  }

  Rx<s.State<bool>> getIsVisitorRegisteredRx() {
    return _visitorIsRegistered;
  }

  @override
  void dispose() {
    try {
      _visitorIsRegistered.close();
      _userIdSubscription?.dispose();
    } catch (e) {
      _logger.d("Dispose streams error", e);
    }
    super.dispose();
  }
}
