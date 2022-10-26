import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/pages/lister_flow.dart';
import '../../data/di/controllers_factories.dart';
import '../../data/widgets/center_horizontal.dart';
import '../../domain/entities/visitor.dart';

class CheckinsPage extends StatelessWidget {
  final controller = Get.put(GetCheckinsControllerFactory().make());

  CheckinsPage({Key? key}) : super(key: key) {
    String? id = Get.parameters['id'];
    controller.setPropertyId(id);
  }

  @override
  Widget build(BuildContext context) {
    return ListerFlow(
        // This is where you give you custom widget it's data.
        body: Obx(() => controller.isLoading()
            ? Center(child: Text('Please wait........................'))
            : Padding(
                padding: const EdgeInsets.all(14.0),
                child: CenterHorizontal(
                  child: Table(
                      defaultColumnWidth: FixedColumnWidth(
                          MediaQuery.of(context).size.width * 0.8),
                      border: TableBorder.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2),
                      children: getRows()),
                ),
              )));
  }

  List<TableRow> getRows() {
    return [
      getListingsHeader(),
      ...controller.getCheckins().map<TableRow>((item) {
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
              child: Text('Checkins',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      )
    ]);
  }

  TableRow getTableRow(Visitor item) {
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Name ${item.name}', textAlign: TextAlign.left),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Email: ${item.email}', textAlign: TextAlign.left),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Phone: ${item.phone}', textAlign: TextAlign.left),
            )
          ],
        ),
      )
    ]);
  }
}
