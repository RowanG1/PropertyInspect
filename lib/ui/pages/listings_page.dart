import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/controllers/listings_controller.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/pages/lister_flow.dart';
import '../../domain/constants.dart';
import '../../domain/entities/listing.dart';
import '../../domain/usecase/analytics_use_case.dart';
import '../controllers/lister_flow_controller.dart';
import '../controllers/lister_registration_controller.dart';

class ListingsPage extends StatefulWidget {
  final AnalyticsUseCase analyticsUseCase;
  final ListerRegistrationController listerRegistrationController;
  final ListerFlowController listerFlowController;
  final ListingsController controller;

  ListingsPage({Key? key, required this.listerRegistrationController, required this.listerFlowController, required this.analyticsUseCase,
    required this.controller}) : super(key: key) {
    Get.put(listerFlowController);
    Get.put(listerRegistrationController);
    Get.put(controller);
  }

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  final loginController = Get.find<LoginController>();
  late final Worker getListingsSubscription;
  late final Worker deleteListingSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getListingsSubscription = ever(widget.controller.getListingsRx(), (value) {
        if (value.error != null && loginController.getLoginState().value ==
            true) {
          Get.snackbar("Get Listings Error", value.error.toString(),
              backgroundColor: Colors.red);
          widget.analyticsUseCase.execute("get_listings_error", { 'error' : value
              .error, 'page': 'listings'});
        }
      });

      deleteListingSubscription = ever(widget.controller.getDeleteState(), (value) {
        if (value.error != null && loginController.getLoginState().value == true) {
          Get.snackbar("Error", value.error.toString(),
              backgroundColor: Colors.red);
          widget.analyticsUseCase.execute("delete_listing_state_error", { 'error' : value
              .error, 'page': 'listings'});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListerFlow(
      pageTitle: "Listings",
      listerFlowController: widget.listerFlowController,
      listerRegistrationController: widget.listerRegistrationController,
      analyticsUseCase: widget.analyticsUseCase,
      // This is where you give you custom widget it's data.
      body: Obx(() => widget.controller.isLoading()
          ? Center(
            child: const CircularProgressIndicator(
                value: null,
                semanticsLabel: 'Circular progress indicator',
              ),
          )
          : ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                      child: ElevatedButton(
                          onPressed: () {
                            const route = '${Constants.createListingRoute}';
                            Get.toNamed('$route');
                          },
                          child: const Text("Create Listing")),
                    ),
                  ],
                ),
                if (widget.controller.getListings().isEmpty) Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('No listings '
                        'currently.'),
                  ),
                ),
                ...getRows()
              ],
            )),
    );
  }

  List<Widget> getRows() {
    return widget.controller.getListings().asMap().map((i, item) => MapEntry(i, getTableRow(item, i)
    )).values.toList();
  }

  Widget getTableRow(Listing item, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: new Border.all(color: Colors.black45),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    width: 70,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 8),
                      child: Text('Address:', textAlign: TextAlign.start),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 8),
                    child: Text(
                      '${item.address}',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 70,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 8),
                      child: Text('Suburb:', textAlign: TextAlign.start),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 8),
                    child: Text(
                      '${item.suburb}',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          final route =
                              '${Constants.listingBaseRoute}/${item.id}';
                          Get.toNamed('$route');
                        },
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("View",
                                textAlign: TextAlign.start, key: ValueKey('view_btn_${index.toString()}'),))),
                    TextButton(
                        onPressed: () {
                          showDeleteDialog(item.id);
                        },
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.delete,
                            color: Colors.grey,
                            size: 24.0,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showDeleteDialog(String? listingId) {
    if (listingId != null) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Confirm delete'),
          content: const Text('Your listing will be deleted'),
          actions: <Widget>[
            TextButton(
              onPressed: () => onCancelDeleteDialog(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => onOkDeleteDialog(listingId),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }
  }

  onCancelDeleteDialog() {
    Navigator.pop(context, 'Cancel');
  }

  onOkDeleteDialog(String listingId) {
    widget.controller.deleteListing(listingId);
    Navigator.pop(context, 'OK');
  }

  @override
  void dispose() {
    getListingsSubscription.dispose();
    deleteListingSubscription.dispose();
    super.dispose();
  }
}
