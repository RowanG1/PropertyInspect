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

    return ListerFlow(
        // This is where you give you custom widget it's data.
        body: Obx(() => controller.isLoading()
            ? Text('Please wait.')
            : Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Text('🏠 Address: $address'),
                    QrImage(
                      data: controller.getQRCodeUrl(),
                      version: QrVersions.auto,
                      size: 200.0,
                    )
                  ]))));
  }
}
