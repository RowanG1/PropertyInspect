import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:property_inspect/domain/usecase/get_is_visitor_registerd_use_case.dart';
import '../../data/types/optional.dart';
import '../../domain/entities/state.dart' as s;
import '../../domain/usecase/get_login_id_use_case.dart';

class VisitorFlowController extends GetxController {
  final Rx<s.State<bool>> _visitorIsRegistered = s.State<bool>().obs;
  final GetLoginIdUseCase _loginIdUseCase;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final GetIsVisitorRegisteredUseCase _isVisitorRegisteredUseCase;
  final Rx<String?> currentPage = (null as String?).obs;

  VisitorFlowController(this._isVisitorRegisteredUseCase, this._loginIdUseCase);

  @override
  void onInit() {
    super.onInit();
    _userId.bindStream(_loginIdUseCase.execute());

    ever(_userId, (id) {
      if (id.value != null) {
        _getIsVisitorRegistered(id.value!);
      }
    });
  }

  _getIsVisitorRegistered(String id) {
    try {
      _visitorIsRegistered.value = s.State<bool>(loading: true);
      final isRegistered =
      _isVisitorRegisteredUseCase.execute(id);

      final mappedIsRegistered =
      isRegistered.map((event) => s.State<bool>(content: event));

      _visitorIsRegistered.bindStream(mappedIsRegistered.handleError(
              (onError) => _visitorIsRegistered.value = s.State<bool>(error: onError)));
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
    _visitorIsRegistered.close();
    super.dispose();
  }
}
