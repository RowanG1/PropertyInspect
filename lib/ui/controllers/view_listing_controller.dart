import 'package:get/get.dart';
import 'package:property_inspect/domain/usecase/get_listing_use_case.dart';
import '../../domain/entities/listing.dart';
import '../../domain/entities/state.dart';

class ViewListingController extends GetxController {
  String? _propertyId;
  GetListingUseCase _getListingUseCase;
  final Rx<State<Listing>> _propertyState = State<Listing>().obs;

  ViewListingController(this._getListingUseCase);

  _getProperty() {
    try {
      _propertyState.value = State<Listing>(loading: true);
      final propertyStream = _getListingUseCase.execute(_propertyId!);
      final Stream<State<Listing>> mappedPropertyStream =
          propertyStream.map<State<Listing>>((event) {
        return State<Listing>(content: event);
      });

      _propertyState.bindStream(mappedPropertyStream.handleError(
          (onError) {
            print(onError);
            _propertyState.value = State<Listing>(error: onError); }
      ));
    } catch (e) {
      print("Error on get listing:");
      print(e);
      _propertyState.value = State<Listing>(
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
}
