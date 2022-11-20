// Mocks generated by Mockito 5.3.2 from annotations
// in property_inspect/test/widgets/drawer_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:mockito/mockito.dart' as _i1;
import 'package:package_info_plus/package_info_plus.dart' as _i2;
import 'package:property_inspect/domain/repository/analytics_repo.dart' as _i6;
import 'package:property_inspect/domain/repository/logout_repo.dart' as _i3;
import 'package:property_inspect/domain/repository/package_repo.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakePackageInfo_0 extends _i1.SmartFake implements _i2.PackageInfo {
  _FakePackageInfo_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [LogoutRepo].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogoutRepo extends _i1.Mock implements _i3.LogoutRepo {
  MockLogoutRepo() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [PackageInfoRepo].
///
/// See the documentation for Mockito's code generation for more information.
class MockPackageInfoRepo extends _i1.Mock implements _i4.PackageInfoRepo {
  MockPackageInfoRepo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.PackageInfo> getPackageInfo() => (super.noSuchMethod(
        Invocation.method(
          #getPackageInfo,
          [],
        ),
        returnValue: _i5.Future<_i2.PackageInfo>.value(_FakePackageInfo_0(
          this,
          Invocation.method(
            #getPackageInfo,
            [],
          ),
        )),
      ) as _i5.Future<_i2.PackageInfo>);
}

/// A class which mocks [AnalyticsRepo].
///
/// See the documentation for Mockito's code generation for more information.
class MockAnalyticsRepo extends _i1.Mock implements _i6.AnalyticsRepo {
  MockAnalyticsRepo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void sendEvent(
    String? type,
    Map<String, dynamic>? content,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #sendEvent,
          [
            type,
            content,
          ],
        ),
        returnValueForMissingStub: null,
      );
}
