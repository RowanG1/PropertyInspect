import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/controllers/login_controller.dart';
import 'package:property_inspect/ui/pages/lister_flow.dart';
import '../../data/di/controllers_factories.dart';
import '../../data/di/use_case_factories.dart';
import '../../domain/constants.dart';
import '../../domain/entities/listing.dart';
import '../../domain/usecase/analytics_use_case.dart';

class ListingsPage extends StatefulWidget {
  ListingsPage({Key? key}) : super(key: key);

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  final controller = Get.put(ViewListingsControllerFactory().make());
  final loginController = Get.find<LoginController>();
  late final Worker getListingsSubscription;
  late final Worker deleteListingSubscription;
  final AnalyticsUseCase _analyticsUseCase = AnalyticsUseCaseFactory().make();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getListingsSubscription = ever(controller.getListingsRx(), (value) {
        if (value.error != null && loginController.getLoginState().value ==
            true) {
          Get.snackbar("Get Listings Error", value.error.toString(),
              backgroundColor: Colors.red);
          _analyticsUseCase.execute("get_listings_error", { 'error' : value
              .error, 'page': 'listings'});
        }
      });

      deleteListingSubscription = ever(controller.getDeleteState(), (value) {
        if (value.error != null) {
          Get.snackbar("Error", value.error.toString(),
              backgroundColor: Colors.red);
          _analyticsUseCase.execute("delete_listing_state_error", { 'error' : value
              .error, 'page': 'listings'});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListerFlow(
      pageTitle: "Listings",
      // This is where you give you custom widget it's data.
      body: Obx(() => controller.isLoading()
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
                if (controller.getListings().isEmpty) Center(
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
    return controller.getListings().map<Widget>((item) {
      return getTableRow(item);
    }).toList();
  }

  Widget getTableRow(Listing item) {
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
                            child: const Text("View",
                                textAlign: TextAlign.start))),
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
    controller.deleteListing(listingId);
    Navigator.pop(context, 'OK');
  }

  @override
  void dispose() {
    getListingsSubscription.dispose();
    deleteListingSubscription.dispose();
    super.dispose();
  }
}
