// Mocks generated by Mockito 5.3.2 from annotations
// in property_inspect/test/widgets/listing_widget_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:property_inspect/domain/entities/listing.dart' as _i4;
import 'package:property_inspect/domain/repository/analytics_repo.dart' as _i5;
import 'package:property_inspect/domain/repository/listing_repo.dart' as _i2;
import 'package:property_inspect/domain/repository/logout_repo.dart' as _i6;

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

/// A class which mocks [ListingRepo].
///
/// See the documentation for Mockito's code generation for more information.
class MockListingRepo extends _i1.Mock implements _i2.ListingRepo {
  MockListingRepo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> createListing(_i4.Listing? listing) => (super.noSuchMethod(
        Invocation.method(
          #createListing,
          [listing],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Stream<bool> isListingAvailable(String? propertyId) =>
      (super.noSuchMethod(
        Invocation.method(
          #isListingAvailable,
          [propertyId],
        ),
        returnValue: _i3.Stream<bool>.empty(),
      ) as _i3.Stream<bool>);
  @override
  _i3.Stream<_i4.Listing?> getListing(dynamic listingId) => (super.noSuchMethod(
        Invocation.method(
          #getListing,
          [listingId],
        ),
        returnValue: _i3.Stream<_i4.Listing?>.empty(),
      ) as _i3.Stream<_i4.Listing?>);
  @override
  _i3.Stream<List<_i4.Listing>> getListings(dynamic userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getListings,
          [userId],
        ),
        returnValue: _i3.Stream<List<_i4.Listing>>.empty(),
      ) as _i3.Stream<List<_i4.Listing>>);
  @override
  _i3.Future<void> deleteListing(String? listingId) => (super.noSuchMethod(
        Invocation.method(
          #deleteListing,
          [listingId],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [AnalyticsRepo].
///
/// See the documentation for Mockito's code generation for more information.
class MockAnalyticsRepo extends _i1.Mock implements _i5.AnalyticsRepo {
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

/// A class which mocks [LogoutRepo].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogoutRepo extends _i1.Mock implements _i6.LogoutRepo {
  MockLogoutRepo() {
    _i1.throwOnMissingStub(this);
  }
}
