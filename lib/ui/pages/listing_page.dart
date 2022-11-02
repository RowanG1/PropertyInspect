import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/pages/lister_flow.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../data/di/controllers_factories.dart';
import '../../domain/constants.dart';
import '../controllers/lister_flow_controller.dart';

class ListingPage extends StatefulWidget {
  final controller = Get.put(ViewListingControllerFactory().make());

  ListingPage({Key? key}) : super(key: key);

  @override
  State<ListingPage> createState() => _ListerFlowState();
}

class _ListerFlowState extends State<ListingPage> {
late final Worker listingSubScription;
late final Worker checkinStateSubScription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      listingSubScription = ever(widget.controller.getListingRx(), (value) {
        if (value.error != null) {
          Get.snackbar("Error", value.error.toString(),
              backgroundColor: Colors.red);
        }
      });

      checkinStateSubScription = ever(widget.controller.getCheckinState(),
      (value) {
        if (value.error != null) {
          Get.snackbar("Error", value.error.toString(),
              backgroundColor: Colors.red);
        }
      });

      String? id = Get.parameters['id'];
      widget.controller.setPropertyId(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListerFlow(pageTitle: "Listing",
        // This is where you give you custom widget it's data.
        body: Obx(() => Center(
            child: widget.controller.isLoading()
                ? CircularProgressIndicator(
                    value: null,
                    semanticsLabel: 'Circular progress indicator',
                  )
                : ((widget.controller.getListing() != null)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 5),
                              child: Text(
                                  "${widget.controller.getListing()?.address}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "${widget.controller.getListing()?.suburb}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "${widget.controller.getListing()?.postCode}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: QrImage(
                                data: widget.controller.getQRCodeUrl(),
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ElevatedButton(
                                  onPressed: widget.controller.doCheckinsExist()
                                      ? () {
                                          final route =
                                              '${Constants.checkinsBaseRoute}/${widget.controller.getPropertyId()}';
                                          Get.toNamed('$route');
                                        }
                                      : null,
                                  child: Align(
                                      widthFactor: 1,
                                      alignment: Alignment.center,
                                      child: const Text("Checkins"))),
                            ),
                          ])
                    : Text('Sorry, we can\'t find the listing.')))));
  }

  @override
  void dispose() {
    listingSubScription.dispose();
    checkinStateSubScription.dispose();
    super.dispose();
  }
}
