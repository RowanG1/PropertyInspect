import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/pages/lister_flow.dart';
import '../../data/di/controllers_factories.dart';
import '../../domain/constants.dart';
import '../../domain/entities/listing.dart';

class ListingsPage extends StatefulWidget {
  ListingsPage({Key? key}) : super(key: key);

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  final controller = Get.put(ViewListingsControllerFactory().make());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ever(controller.getListingsRx(), (value) {
        if (value.error != null) {
          Get.snackbar("Error", value.error.toString(),
              backgroundColor: Colors.red);
        }
      });

      ever(controller.getDeleteState(), (value) {
        if (value.error != null) {
          Get.snackbar("Error", value.error.toString(),
              backgroundColor: Colors.red);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListerFlow(
        // This is where you give you custom widget it's data.
        body: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: controller.isLoading()
                        ? Text('Please wait........................')
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 30,
                                    0, 0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        const route =
                                            '${Constants.createListingRoute}';
                                        Get.toNamed('$route');
                                      },
                                      child: const Text("Create Listing")),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 30,
                                    0, 0),
                                  child: Table(
                                      defaultColumnWidth: FixedColumnWidth(
                                          MediaQuery.of(context).size.width *
                                              0.8),
                                      border: TableBorder.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 1),
                                      children: getRows()),
                                )
                              ])),
              ],
            )));
  }

  List<TableRow> getRows() {
    return [
      getListingsHeader(),
      ...controller.getListings().map<TableRow>((item) {
        return getTableRow(item);
      }).toList()
    ];
  }

  TableRow getListingsHeader() {
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Listings',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            )
          ],
        ),
      )
    ]);
  }

  TableRow getTableRow(Listing item) {
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 8, 8, 8),
              child: Text(item.address, textAlign: TextAlign.start),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  TextButton(
                      onPressed: () {
                        final route = '${Constants.listingBaseRoute}/${item.id}';
                        Get.toNamed('$route');
                      },
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text("View", textAlign: TextAlign.start))),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(80.0, 0, 0, 0),
                    child: TextButton(
                        onPressed: () {
                          showDeleteDialog(item.id);
                        },
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.delete,
                              color: Colors.grey,
                              size: 24.0,
                              semanticLabel: 'Text to announce in accessibility modes',
                            ),)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
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
              child: const Text('OK', style: TextStyle(color: Colors.red),),
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
}
