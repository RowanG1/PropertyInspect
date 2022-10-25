import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/pages/lister_flow.dart';
import '../../data/di/controllers_factories.dart';
import '../../domain/constants.dart';
import '../../domain/entities/listing.dart';

class ListingsPage extends StatelessWidget {
  final controller = Get.put(ViewListingsControllerFactory().make());

  ListingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListerFlow(
        // This is where you give you custom widget it's data.
        body: Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextButton(
                      onPressed: () {
                        Get.toNamed(Constants.homeRoute);
                      },
                      child: const Text("Go to home")),
                ),
                Center(
                    child: controller.isLoading()
                        ? Text('Please wait........................')
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text('Listings',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        const route =
                                            '${Constants.createListingRoute}';
                                        Get.toNamed('$route');
                                      },
                                      child: const Text("Create Listing")),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Table(
                                      defaultColumnWidth:
                                          const FixedColumnWidth(120.0),
                                      border: TableBorder.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 2),
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
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Listing',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
              padding: const EdgeInsets.all(8.0),
              child: Text(item.address, textAlign: TextAlign.start),
            ),
            TextButton(
                onPressed: () {
                  final route = '${Constants.listingBaseRoute}/${item.id}';
                  Get.toNamed('$route');
                },
                child: Align(alignment: Alignment.centerLeft, child: const
                Text("View",
                    textAlign: TextAlign
                    .start))),
            TextButton(
                onPressed: () {
                  controller.deleteListing(item.id!);
                },
                child: Align(alignment: Alignment.centerLeft, child: const
                Text("Delete"))),
            TextButton(
                onPressed: () {
                  final route = '${Constants.checkinsBaseRoute}/${item.id}';
                  Get.toNamed('$route');
                },
                child: Align(alignment: Alignment.centerLeft, child: const
                Text("Show Checkins")))
          ],
        ),
      ),
    ]);
  }
}
