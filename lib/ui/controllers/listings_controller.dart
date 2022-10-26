import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/usecase/delete_listing_use_case.dart';
import '../../data/types/optional.dart';
import '../../domain/entities/listing.dart';
import '../../domain/entities/state.dart' as s;
import '../../domain/usecase/get_listings_use_case.dart';
import '../../domain/usecase/get_login_id_use_case.dart';

class ListingsController extends GetxController {
  GetListingsUseCase _getListingsUseCase;
  GetLoginIdUseCase _getLoginIdUseCase;
  DeleteListingUseCase _deleteListingUseCase;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final Rx<s.State<List<Listing>>> _propertiesState = s.State<List<Listing>>().obs;
  ListingsController(this._getListingsUseCase, this._getLoginIdUseCase, this
      ._deleteListingUseCase);

  @override
  void onInit() {
    super.onInit();
    final Stream<Optional<String>> loginIdStream = _getLoginIdUseCase.execute();
    _userId.bindStream(loginIdStream);
    ever(_userId, (value) {
      final userId = value.value;
      if (userId != null) {
       _getProperties(userId);
      }
    });

    ever(_propertiesState, (value) {
      if (value.error != null) {
        Get.snackbar("Error", value.error.toString(), backgroundColor: Colors.red);
      }
    });
  }

  _getProperties(String userId) {
    try {
      _propertiesState.value = s.State<List<Listing>>(loading: true);
      final propertiesStream = _getListingsUseCase.execute(userId);
      final Stream<s.State<List<Listing>>> mappedPropertiesStream =
      propertiesStream.map<s.State<List<Listing>>>((event) {
        return s.State<List<Listing>>(content: event);
      });

      _propertiesState.bindStream(mappedPropertiesStream.handleError(
              (onError) {
            print(onError);
            _propertiesState.value = s.State<List<Listing>>(error: onError); }
      ));
    } catch (e) {
      print("Error on get listing:");
      print(e);
      _propertiesState.value = s.State<List<Listing>>(
          error: Exception("Could not "
              "get property available state."));
    }
  }

  List<Listing> getListings() {
    final listings = _propertiesState.value.content ?? [];
    print('Listings:');
    print(listings);
    return _propertiesState.value.content ?? [];
  }

  deleteListing(String listingId) async {
    await _deleteListingUseCase.execute(listingId);
  }

  bool isLoading() {
    return _propertiesState.value.loading;
  }
}
