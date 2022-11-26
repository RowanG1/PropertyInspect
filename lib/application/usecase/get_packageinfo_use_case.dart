import 'package:package_info_plus/package_info_plus.dart';
import 'package:property_inspect/domain/repository/package_repo.dart';

class GetPackageInfoUseCase {
  final PackageInfoRepo _packageInfoRepo;

  GetPackageInfoUseCase(this._packageInfoRepo);

  Future<PackageInfo> execute() {
    return _packageInfoRepo.getPackageInfo();
  }
}