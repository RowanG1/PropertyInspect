import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/pages/lister_flow.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../data/di/controllers_factories.dart';

class ListingPage extends StatefulWidget {
  final controller = Get.put(ViewListingControllerFactory().make());

  ListingPage({
    super.key
  });

  @override
  State<ListingPage> createState() => _ListerFlowState();
}

class _ListerFlowState extends State<ListingPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      ever(widget.controller.getListingRx(), (value) {
        if (value.error != null) {
          Get.snackbar("Error", value.error.toString(), backgroundColor:
          Colors.red);
        }
      });

      String? id = Get.parameters['id'];
      widget.controller.setPropertyId(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListerFlow(
      // This is where you give you custom widget it's data.
        body: Obx(() => Center(
            child: widget.controller.isLoading()
                ? Text('Please wait........................')
                : ((widget.controller.getListing() != null)
                ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "🏠 Address: ${widget.controller.getListing()?.address}"),
                  QrImage(
                    data: widget.controller.getQRCodeUrl(),
                    version: QrVersions.auto,
                    size: 200.0,
                  )
                ])
                : Text('Sorry, we can\'t find the listing.')))));
  }
}
