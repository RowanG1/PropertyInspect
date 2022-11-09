import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:property_inspect/ui/controllers/PackageController.dart';

class MyMockPackageController extends PackageController {
  Rx<PackageInfo?> _packageInfo = PackageInfo(appName: "Good", version: '23', buildNumber: '43', packageName: "MyPackage").obs;

  @override
  getPackageInfo() {
    return _packageInfo.value;
  }
}