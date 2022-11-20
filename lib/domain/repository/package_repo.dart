import 'package:package_info_plus/package_info_plus.dart';

abstract class PackageInfoRepo {
  Future<PackageInfo> getPackageInfo();
}