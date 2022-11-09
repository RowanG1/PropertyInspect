import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class TestModeController extends GetxController {
  Rx<bool> isTestMode = false.obs;

  TestModeController({bool isTestMode = false}) {
    this.isTestMode.value = isTestMode;
  }
}
