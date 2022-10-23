import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/pages/lister_flow.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../data/di/controllers_factories.dart';
import '../../domain/constants.dart';

class ListingPage extends StatelessWidget {
  final controller = Get.put(ViewListingControllerFactory().make());

  ListingPage({Key? key}) : super(key: key) {
    String? id = Get.parameters['id'];
    controller.setPropertyId(id);
  }

  @override
  Widget build(BuildContext context) {
    final listing = controller.getListing();
    final address = listing?.address;
    final listingId = controller.getPropertyId();
    final origin = Uri.base.origin;
    final checkinRoute = Constants.checkinBaseRoute;
    final checkinUrl = '$origin/#$checkinRoute/$listingId';
    print('Checkin url: $checkinUrl');
    return ListerFlow(
        // This is where you give you custom widget it's data.
        body: Obx(() => controller.isLoading()
            ? Text('Please wait.')
            : Center(child: Column(children: [Text('🏠 Address: $address'), QrImage(
          data: checkinUrl,
          version: QrVersions.auto,
          size: 200.0,
        )],
            crossAxisAlignment:
        CrossAxisAlignment.center))));
  }
}
