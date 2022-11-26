import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:property_inspect/domain/repository/package_repo.dart';
import 'package:property_inspect/application/usecase/get_packageinfo_use_case.dart';
import 'package:property_inspect/ui/controllers/package_controller.dart';
import 'mock_package_controller.mocks.dart';

@GenerateMocks([PackageInfoRepo])
class MyMockPackageControllerFactory {
  Future<PackageInfo> _getPackageInfo() {
    final packageInfo = PackageInfo(appName: "Good", version: '23',
        buildNumber: '43',
        packageName:
        "MyPackage");
    return Future<PackageInfo>.value(packageInfo);
  }

  make() {
    final packageInfoRepo = MockPackageInfoRepo();
    final packageInfoUseCase = GetPackageInfoUseCase(packageInfoRepo);
    when(packageInfoRepo.getPackageInfo()).thenAnswer((_) => _getPackageInfo());
    return PackageController(packageInfoUseCase);
  }
}