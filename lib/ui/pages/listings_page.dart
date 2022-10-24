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
        body: Obx(() => Center(
            child: controller.isLoading()
                ? Text('Please wait........................')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Listings',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextButton(
                              onPressed: () {
                                const route = '${Constants.createListingRoute}';
                                Get.toNamed('$route');
                              },
                              child: const Text("Create Listing")),
                        ),
                        Table(
                            defaultColumnWidth: const FixedColumnWidth(120.0),
                            border: TableBorder.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 2),
                            children: getRows())
                      ]))));
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
              child: Text('Address',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[],
        ),
      ),
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[],
        ),
      )
    ]);
  }

  TableRow getTableRow(Listing item) {
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.address, textAlign: TextAlign.center),
            )
          ],
        ),
      ),
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  final route = '${Constants.listingBaseRoute}/${item.id}';
                  Get.toNamed('$route');
                },
                child: const Text("View"))
          ],
        ),
      ),
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  controller.deleteListing(item.id!);
                },
                child: const Text("Delete"))
          ],
        ),
      )
    ]);
  }
}
