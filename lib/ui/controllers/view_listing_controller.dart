// ignore_for_file: unnecessary_cast

import 'dart:async';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:property_inspect/application/usecase/do_checkins_exist_use_case.dart';
import 'package:property_inspect/application/usecase/get_listing_use_case.dart';
import '../../data/types/optional.dart';
import '../../domain/constants.dart';
import '../../domain/entities/listing.dart';
import '../../data/types/state.dart' as s;
import '../../application/usecase/get_login_id_use_case.dart';
import 'package:rxdart/rxdart.dart' as rx_raw;

class ViewListingController extends GetxController {
  final Rx<String?> _propertyId = (null as String?).obs;
  final GetListingUseCase _getListingUseCase;
  final DoCheckinsExistForListingUseCase _doCheckinsExistForListingUseCase;
  final GetLoginIdUseCase _getLoginIdUseCase;
  final Rx<Optional<String>> _userId = Optional<String>(null).obs;
  final Rx<s.State<Listing>> _propertyState = s.State<Listing>().obs;
  final Rx<s.State<bool>> _checkinExistState = s.State<bool>().obs;
  late final Rx<CheckinsExistLumpedInput?> lumpedCheckinsExistDataRx = (null as CheckinsExistLumpedInput?).obs;
  Logger logger = Get.find();
  late StreamSubscription<bool?> checkinExistStream;

  ViewListingController(this._getListingUseCase, this._doCheckinsExistForListingUseCase, this._getLoginIdUseCase);

  @override
  void onInit() {
    super.onInit();
    setupStreams();
  }

  setupStreams() {
    logger.d("Setting up streams.");
    final loginIdStream = _getLoginIdUseCase.execute().asBroadcastStream();
    _userId.bindStream(loginIdStream);

    final propertyIdStream = _propertyId.stream.asBroadcastStream();

    final lumpedCheckinsExistData = rx_raw.Rx.combineLatest2(loginIdStream, propertyIdStream, (loginId, propertyId) {
      return CheckinsExistLumpedInput(propertyId, loginId.value);
    }).asBroadcastStream();

    lumpedCheckinsExistDataRx.bindStream(lumpedCheckinsExistData);

    ever(lumpedCheckinsExistDataRx, (event) {
      if (event != null) {
        final listingId = event.listingId;
        final listerId = event.listerId;
        if (listingId != null && listerId != null) {
          _getProperty();
          _doCheckinsExist(listerId, listingId);
        }
      }
    });
  }

  _getProperty() {
    try {
      _propertyState.value = s.State<Listing>(loading: true);
      final propertyStream = _getListingUseCase.execute(_propertyId.value!);
      final Stream<s.State<Listing>> mappedPropertyStream = propertyStream.map<s.State<Listing>>((event) {
        return s.State<Listing>(content: event);
      });

      _propertyState.bindStream(mappedPropertyStream.handleError((onError) {
        _propertyState.value = s.State<Listing>(error: onError);
      }));
    } catch (e) {
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
  }

  String? getPropertyId() {
    return _propertyId.value;
  }

  bool isLoading() {
    return _propertyState.value.loading;
  }

  String getQRCodeUrl() {
    final listingId = getPropertyId();
    String origin;
    try {
      origin = Uri.base.origin;
    } catch (e) {
      origin = "http:";
    }

    const checkinRoute = Constants.checkinBaseRoute;
    final checkinUrl = '$origin/#$checkinRoute/$listingId';
    return checkinUrl;
  }

  _doCheckinsExist(String listerId, String propertyId) {
    if (_propertyState.value.content == null) {
      _propertyState.value = s.State<Listing>(loading: true);
    }
    try {
      logger.d('Start');
      final checkinsExistStream = _doCheckinsExistForListingUseCase.execute(listerId, propertyId).asBroadcastStream();
      checkinExistStream = checkinsExistStream.listen((event) {
        logger.d('Got value for checkin exist stream: $event');
      }, onDone: () {
        logger.d('Checkin exist stream done.');
      });

      final checkinExistStateStream = checkinsExistStream.map((event) => s.State<bool>(content: event));
      _checkinExistState.bindStream(checkinExistStateStream.handleError((onError) {
        _checkinExistState.value = s.State<bool>(error: onError);
        logger.e('Error', onError);
      }));
      logger.d('End');
    } catch (e) {
      _checkinExistState.value = s.State<bool>(error: Exception('$e'));
      logger.e('Error', e);
    }
  }

  Rx<s.State<bool>> getCheckinState() {
    return _checkinExistState;
  }

  bool doCheckinsExist() {
    return _checkinExistState.value.content == true;
  }

  @override
  void dispose() {
    lumpedCheckinsExistDataRx.close();
    _checkinExistState.close();
    _propertyState.close();
    checkinExistStream.cancel();
    super.dispose();
  }
}

class CheckinsExistLumpedInput {
  String? listingId;
  String? listerId;

  CheckinsExistLumpedInput(this.listingId, this.listerId);
}
