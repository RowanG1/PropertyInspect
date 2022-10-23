import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:property_inspect/domain/usecase/is_lister_registered_use_case.dart';
import '../../data/types/optional.dart';
import '../../domain/entities/state.dart';
import '../../domain/usecase/get_login_id_use_case.dart';

class ListerFlowController extends GetxController {
  final Rx<State<bool>> _listerIsRegistered = State<bool>().obs;
  final GetLoginIdUseCase _loginIdUseCase;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final IsListerRegisteredUseCase _isListerRegisteredUseCase;

  ListerFlowController(this._isListerRegisteredUseCase, this._loginIdUseCase);

  @override
  void onInit() {
    super.onInit();
    _userId.bindStream(_loginIdUseCase.execute());

    ever(_userId, (id) {
      if (id.value != null) {
        _getIsListerRegistered(id.value!);
      }
    });
  }

  _getIsListerRegistered(String id) {
    try {
      _listerIsRegistered.value = State<bool>(loading: true);
      final isRegistered =
      _isListerRegisteredUseCase.execute(id);

      final mappedIsRegistered =
      isRegistered.map((event) => State<bool>(content: event));

      _listerIsRegistered.bindStream(mappedIsRegistered.handleError(
              (onError) => _listerIsRegistered.value = State<bool>(error: onError)));
    } catch (e) {
      _listerIsRegistered.value = State<bool>(error: Exception("$e"));
    }
  }

  getIsLoading() {
    return _listerIsRegistered.value.loading;
  }

  bool getIsListerRegistered() {
    return _listerIsRegistered.value.content == true;
  }
}
