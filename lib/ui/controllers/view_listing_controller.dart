import 'package:get/get.dart';
import 'package:property_inspect/domain/usecase/do_checkins_exist_use_case.dart';
import 'package:property_inspect/domain/usecase/get_listing_use_case.dart';
import '../../data/types/optional.dart';
import '../../domain/constants.dart';
import '../../domain/entities/listing.dart';
import '../../domain/entities/state.dart' as s;
import '../../domain/usecase/get_login_id_use_case.dart';
import 'package:rxdart/rxdart.dart' as RxRaw;

class ViewListingController extends GetxController {
  Rx<String?> _propertyId = (null as String?).obs;
  GetListingUseCase _getListingUseCase;
  DoCheckinsExistForListingUseCase _doCheckinsExistForListingUseCase;
  GetLoginIdUseCase _getLoginIdUseCase;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final Rx<s.State<Listing>> _propertyState = s.State<Listing>().obs;
  final Rx<s.State<bool>> _checkinExistState = s.State<bool>().obs;

  ViewListingController(this._getListingUseCase,
      this._doCheckinsExistForListingUseCase, this._getLoginIdUseCase);

  @override
  void onInit() {
    super.onInit();

    final loginIdStream = _getLoginIdUseCase.execute();
    _userId.bindStream(loginIdStream);

    final propertyIdStream = _propertyId.stream;

    final lumpedCheckinsExistData = RxRaw.Rx.combineLatest2(
        loginIdStream, propertyIdStream, (loginId, propertyId) {
          return CheckinsExistLumpedInput(propertyId, loginId.value);
    });

    lumpedCheckinsExistData.listen((event) {
      final listingId = event.listingId;
      final listerId = event.listerId;
      if (listingId != null && listerId != null) {
        _doCheckinsExist(listerId, listingId);
      }
    });
  }

  _getProperty() {
    try {
      _propertyState.value = s.State<Listing>(loading: true);
      final propertyStream = _getListingUseCase.execute(_propertyId.value!);
      final Stream<s.State<Listing>> mappedPropertyStream =
          propertyStream.map<s.State<Listing>>((event) {
        print("Mapped value:");
        print(event);
        return s.State<Listing>(content: event);
      });

      _propertyState.bindStream(mappedPropertyStream.handleError((onError) {
        print('Error is:');
        print(onError);
        _propertyState.value = s.State<Listing>(error: onError);
      }));
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

  Rx<s.State<Listing>> getListingRx() {
    return _propertyState;
  }

  void setPropertyId(String? propertyId) {
    _propertyId.value = propertyId;
    if (propertyId != null) {
      print('Setting propertyId in view listing $propertyId');
      _getProperty();
    }
  }

  String? getPropertyId() {
    return _propertyId.value;
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

  _doCheckinsExist(String listerId, String propertyId) {
    _propertyState.value = s.State<Listing>(loading: true);
    print("Running checkins exist");
    try {
      final checkinsExistStream =
          _doCheckinsExistForListingUseCase.execute(listerId, propertyId);
      final checkinExistStateStream =
          checkinsExistStream.map((event) => s.State<bool>(content: event));
      _checkinExistState.bindStream(checkinExistStateStream);
    } catch (e) {
      _checkinExistState.value = s.State<bool>(error: Exception('$e'));
    }
  }

  Rx<s.State<bool>> getCheckinState() {
    return _checkinExistState;
  }

  bool doCheckinsExist() {
    return _checkinExistState.value.content == true;
  }
}

class CheckinsExistLumpedInput {
  String? listingId;
  String? listerId;

  CheckinsExistLumpedInput(this.listingId, this.listerId);
}
