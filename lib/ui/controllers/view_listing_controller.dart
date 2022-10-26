import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/domain/usecase/get_listing_use_case.dart';
import '../../domain/constants.dart';
import '../../domain/entities/listing.dart';
import '../../domain/entities/state.dart' as s;

class ViewListingController extends GetxController {
  String? _propertyId;
  GetListingUseCase _getListingUseCase;
  final Rx<s.State<Listing>> _propertyState = s.State<Listing>().obs;

  ViewListingController(this._getListingUseCase);

  @override
  void onInit() {
    super.onInit();
    ever(_propertyState, (value) {
      if (value.error != null) {
        Get.snackbar("Error", value.error.toString(), backgroundColor: Colors.red);
      }
    });
  }

  _getProperty() {
    try {
      _propertyState.value = s.State<Listing>(loading: true);
      final propertyStream = _getListingUseCase.execute(_propertyId!);
      final Stream<s.State<Listing>> mappedPropertyStream =
          propertyStream.map<s.State<Listing>>((event) {
            print("Mapped value:");
            print(event);
        return s.State<Listing>(content: event);
      });

      _propertyState.bindStream(mappedPropertyStream.handleError(
          (onError) {
            print(onError);
            _propertyState.value = s.State<Listing>(error: onError); }
      ));
    } catch (e) {
      print("Error on get listing:");
      print(e);
      _propertyState.value = s.State<Listing>(
          error: Exception("Could not "
              "get property available state."));
    }
  }

  Listing? getListing() {
    return _propertyState.value.content;
  }

  void setPropertyId(String? propertyId) {
    _propertyId = propertyId;
    if (propertyId != null) {
      print('Setting propertyId in view listing $propertyId');
      _getProperty();
    }
  }

  String? getPropertyId() {
    return _propertyId;
  }

  bool isLoading() {
    return _propertyState.value.loading;
  }

  String getQRCodeUrl() {
    final listingId = getPropertyId();
    final origin = Uri.base.origin;
    const checkinRoute = Constants.checkinBaseRoute;
    final checkinUrl = '$origin/#$checkinRoute/$listingId';
    return checkinUrl;
  }
}
