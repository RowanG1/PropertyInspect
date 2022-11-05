import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageController extends GetxController {
  Rx<PackageInfo?> _packageInfo = (null as PackageInfo?).obs;

  @override
  void onInit() {
    super.onInit();
    _getPackageInfo();
  }

  _getPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    print('Package info is:');
    print(packageInfo);
    _packageInfo.value = packageInfo;
  }

  PackageInfo? getPackageInfo() {
    return _packageInfo.value;
  }
}
