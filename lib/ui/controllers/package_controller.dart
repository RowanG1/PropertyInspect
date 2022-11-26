import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:property_inspect/application/usecase/get_packageinfo_use_case.dart';

class PackageController extends GetxController {
  // ignore: unnecessary_cast
  final Rx<PackageInfo?> _packageInfo = (null as PackageInfo?).obs;
  final GetPackageInfoUseCase _packageInfoUseCase;

  PackageController(this._packageInfoUseCase);

  @override
  void onInit() {
    super.onInit();
    _getPackageInfo();
  }

  _getPackageInfo() async {
    _packageInfo.value = await _packageInfoUseCase.execute();
  }

  PackageInfo? getPackageInfo() {
    return _packageInfo.value;
  }
}
