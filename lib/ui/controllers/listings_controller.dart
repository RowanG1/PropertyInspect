import 'dart:async';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:property_inspect/application/usecase/delete_listing_use_case.dart';
import '../../data/types/optional.dart';
import '../../domain/entities/listing.dart';
import '../../data/types/state.dart' as s;
import '../../application/usecase/get_listings_use_case.dart';
import '../../application/usecase/get_login_id_use_case.dart';

class ListingsController extends GetxController {
  final GetListingsUseCase _getListingsUseCase;
  final GetLoginIdUseCase _getLoginIdUseCase;
  final DeleteListingUseCase _deleteListingUseCase;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final Rx<s.State<List<Listing>>> _propertiesState = s.State<List<Listing>>().obs;
  final Rx<s.State<bool>> _deletePropertiesState = s.State<bool>().obs;
  ListingsController(this._getListingsUseCase, this._getLoginIdUseCase, this._deleteListingUseCase);
  Worker? userIdSubscription;
  final Logger _logger = Get.find();

  @override
  void onInit() {
    super.onInit();
    final Stream<Optional<String>> loginIdStream = _getLoginIdUseCase.execute();
    _userId.bindStream(loginIdStream);

    userIdSubscription = ever(_userId, (value) {
      final userId = value.value;
      if (userId != null) {
        _getProperties(userId);
      }
    });
  }

  _getProperties(String userId) {
    try {
      _propertiesState.value = s.State<List<Listing>>(loading: true);
      final propertiesStream = _getListingsUseCase.execute(userId);
      final Stream<s.State<List<Listing>>> propertiesState = propertiesStream.map<s.State<List<Listing>>>((event) {
        return s.State<List<Listing>>(content: event);
      });
      propertiesState.handleError((onError) {
        _propertiesState.value = s.State<List<Listing>>(error: onError);
      });

      _propertiesState.bindStream(propertiesState);
    } catch (e) {
      _propertiesState.value = s.State<List<Listing>>(
          error: Exception("Could not "
              "get properties."));
    }
  }

  Rx<s.State<List<Listing>>> getListingsRx() {
    return _propertiesState;
  }

  List<Listing> getListings() {
    return _propertiesState.value.content ?? [];
  }

  deleteListing(String listingId) async {
    try {
      await _deleteListingUseCase.execute(listingId);
    } catch (e) {
      _deletePropertiesState.value = s.State<bool>(
          error: Exception("Could not "
              "delete property. $e"));
    }
  }

  Rx<s.State<bool>> getDeleteState() {
    return _deletePropertiesState;
  }

  bool isLoading() {
    return _propertiesState.value.loading;
  }

  @override
  void dispose() {
    try {
      _propertiesState.close();
      userIdSubscription?.dispose();
    } catch (e) {
      _logger.d("Dispose streams error", e);
    }
    super.dispose();
  }
}
