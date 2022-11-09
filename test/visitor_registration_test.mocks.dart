// Mocks generated by Mockito 5.0.7 from annotations
// in property_inspect/test/visitor_registration_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:property_inspect/domain/entities/visitor.dart' as _i3;
import 'package:property_inspect/domain/repository/analytics_repo.dart' as _i5;
import 'package:property_inspect/domain/repository/visitor_registration_repo.dart'
    as _i2;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: prefer_const_constructors

// ignore_for_file: avoid_redundant_argument_values

/// A class which mocks [VisitorRegistrationRepo].
///
/// See the documentation for Mockito's code generation for more information.
class MockVisitorRegistrationRepo extends _i1.Mock
    implements _i2.VisitorRegistrationRepo {
  MockVisitorRegistrationRepo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void createVisitorRegistration(_i3.Visitor? visitor) => super.noSuchMethod(
      Invocation.method(#createVisitorRegistration, [visitor]),
      returnValueForMissingStub: null);
  @override
  _i4.Stream<bool> getIsVisitorRegistered(String? id) =>
      (super.noSuchMethod(Invocation.method(#getIsVisitorRegistered, [id]),
          returnValue: Stream<bool>.empty()) as _i4.Stream<bool>);
  @override
  _i4.Stream<_i3.Visitor?> getVisitor(String? id) => (super.noSuchMethod(
      Invocation.method(#getVisitor, [id]),
      returnValue: Stream<_i3.Visitor?>.empty()) as _i4.Stream<_i3.Visitor?>);
}

/// A class which mocks [AnalyticsRepo].
///
/// See the documentation for Mockito's code generation for more information.
class MockAnalyticsRepo extends _i1.Mock implements _i5.AnalyticsRepo {
  MockAnalyticsRepo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void sendEvent(String? type, Map<String, dynamic>? content) =>
      super.noSuchMethod(Invocation.method(#sendEvent, [type, content]),
          returnValueForMissingStub: null);
}
