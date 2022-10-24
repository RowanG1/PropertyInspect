import 'package:get/get.dart';
import '../../domain/entities/listing.dart';
import '../../domain/entities/state.dart';
import '../../domain/usecase/get_listings_use_case.dart';

class ListingsController extends GetxController {
  String? _propertyId;
  GetListingsUseCase _getListingsUseCase;
  final Rx<State<List<Listing>>> _propertiesState = State<List<Listing>>().obs;

  ListingsController(this._getListingsUseCase);

  _getProperties() {
    try {
      _propertiesState.value = State<List<Listing>>(loading: true);
      final propertiesStream = _getListingsUseCase.execute(_propertyId!);
      final Stream<State<List<Listing>>> mappedPropertiesStream =
      propertiesStream.map<State<List<Listing>>>((event) {
        return State<List<Listing>>(content: event);
      });

      _propertiesState.bindStream(mappedPropertiesStream.handleError(
              (onError) {
            print(onError);
            _propertiesState.value = State<List<Listing>>(error: onError); }
      ));
    } catch (e) {
      print("Error on get listing:");
      print(e);
      _propertiesState.value = State<List<Listing>>(
          error: Exception("Could not "
              "get property available state."));
    }
  }

  List<Listing> getListings() {
    return _propertiesState.value.content ?? [];
  }

  bool isLoading() {
    return _propertiesState.value.loading;
  }
}
