import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/pages/lister_flow.dart';
import '../../data/di/controllers_factories.dart';
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
                    children: [ Text('Listings'),
                        Table(
                            defaultColumnWidth: FixedColumnWidth(120.0),
                            border: TableBorder.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 2),
                            children: controller.getListings().map<TableRow>((item) {
                              return getTableRow(item);
                            }).toList())
                      ]))));
  }

  TableRow getTableRow(Listing item) {
    return TableRow(children: [TableCell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Text('Address:'),
          new Text(item.address),
        ],
      ),
    )]);
  }
}
