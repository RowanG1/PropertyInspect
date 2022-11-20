import 'package:package_info_plus/package_info_plus.dart';
import 'package:property_inspect/domain/repository/package_repo.dart';

class PackageInfoFlutter implements PackageInfoRepo {
  @override
  Future<PackageInfo> getPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}