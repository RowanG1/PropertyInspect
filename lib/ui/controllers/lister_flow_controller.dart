import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:property_inspect/application/usecase/is_lister_registered_use_case.dart';
import '../../data/types/optional.dart';
import '../../data/types/state.dart' as s;
import '../../application/usecase/get_login_id_use_case.dart';

class ListerFlowController extends GetxController {
  final Rx<s.State<bool>> _listerIsRegistered = s
      .State<bool>()
      .obs;
  final GetLoginIdUseCase _loginIdUseCase;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final IsListerRegisteredUseCase _isListerRegisteredUseCase;
  // ignore: unnecessary_cast
  final Rx<String?> currentPage = (null as String?).obs;
  Worker? _userIdSubscription;
  final Logger _logger = Get.find();

  ListerFlowController(this._isListerRegisteredUseCase, this._loginIdUseCase);

  @override
  void onInit() {
    super.onInit();
    _userId.bindStream(_loginIdUseCase.execute());

    _userIdSubscription = ever(_userId, (id) {
      if (id.value != null) {
        _getIsListerRegistered(id.value!);
      }
    });
  }

  _getIsListerRegistered(String id) {
    try {
      _listerIsRegistered.value = s.State<bool>(loading: true);
      final isRegistered =
      _isListerRegisteredUseCase.execute(id);

      final isRegisteredState =
      isRegistered.map((event) => s.State<bool>(content: event));
      isRegisteredState.handleError(
              (onError) => _listerIsRegistered.value = s.State<bool>(error: onError));

      _listerIsRegistered.bindStream(isRegisteredState);
    } catch (e) {
      _listerIsRegistered.value = s.State<bool>(error: Exception("$e"));
    }
  }

  getIsLoading() {
    return _listerIsRegistered.value.loading;
  }

  bool getIsListerRegistered() {
    return _listerIsRegistered.value.content == true;
  }

  Rx<s.State<bool>> getIsListerRegisteredRx() {
    return _listerIsRegistered;
  }

  @override
  void dispose() {
    try {
      _listerIsRegistered.close();
      _userIdSubscription?.dispose();
    } catch (e) {
      _logger.d("Dispose streams error", e);
    }
    super.dispose();
  }
}
