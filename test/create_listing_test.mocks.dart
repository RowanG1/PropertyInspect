// Mocks generated by Mockito 5.0.7 from annotations
// in property_inspect/test/create_listing_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:property_inspect/domain/entities/listing.dart' as _i4;
import 'package:property_inspect/domain/repository/listing_repo.dart' as _i2;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: prefer_const_constructors

// ignore_for_file: avoid_redundant_argument_values

/// A class which mocks [ListingRepo].
///
/// See the documentation for Mockito's code generation for more information.
class MockListingRepo extends _i1.Mock implements _i2.ListingRepo {
  MockListingRepo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> createListing(_i4.Listing? listing) =>
      (super.noSuchMethod(Invocation.method(#createListing, [listing]),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
  @override
  _i3.Stream<bool> isListingAvailable(String? propertyId) =>
      (super.noSuchMethod(Invocation.method(#isListingAvailable, [propertyId]),
          returnValue: Stream<bool>.empty()) as _i3.Stream<bool>);
  @override
  _i3.Stream<_i4.Listing?> getListing(dynamic listingId) => (super.noSuchMethod(
      Invocation.method(#getListing, [listingId]),
      returnValue: Stream<_i4.Listing?>.empty()) as _i3.Stream<_i4.Listing?>);
  @override
  _i3.Stream<List<_i4.Listing>> getListings(dynamic userId) =>
      (super.noSuchMethod(Invocation.method(#getListings, [userId]),
              returnValue: Stream<List<_i4.Listing>>.empty())
          as _i3.Stream<List<_i4.Listing>>);
  @override
  _i3.Future<void> deleteListing(String? listingId) =>
      (super.noSuchMethod(Invocation.method(#deleteListing, [listingId]),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
}
