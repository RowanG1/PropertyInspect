import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/pages/lister_flow.dart';
import '../../data/di/controllers_factories.dart';

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
                children: [])
                )));
  }
}
