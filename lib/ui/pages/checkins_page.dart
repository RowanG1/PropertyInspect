import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_inspect/ui/pages/lister_flow.dart';
import '../../data/di/controllers_factories.dart';
import '../../data/di/use_case_factories.dart';
import '../../domain/entities/visitor.dart';
import '../../domain/usecase/analytics_use_case.dart';
import '../controllers/lister_flow_controller.dart';
import '../controllers/lister_registration_controller.dart';
import '../controllers/login_controller.dart';

class CheckinsPage extends StatefulWidget {
  final ListerRegistrationController listerRegistrationController;
  final ListerFlowController listerFlowController;
  final AnalyticsUseCase analyticsUseCase;

  const CheckinsPage({Key? key, required this.listerRegistrationController, required this.listerFlowController, required this.analyticsUseCase}) : super(key: key);

  @override
  State<CheckinsPage> createState() => _CheckinsPageState();
}

class _CheckinsPageState extends State<CheckinsPage> {
  final controller = Get.put(GetCheckinsControllerFactory().make());
  final loginController = Get.find<LoginController>();
  final AnalyticsUseCase _analyticsUseCase = AnalyticsUseCaseFactory().make();
  late final Worker getCheckinsSubscription;

  @override
  void initState() {
    super.initState();
    String? id = Get.parameters['id'];
    controller.setPropertyId(id);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCheckinsSubscription = ever(controller.getCheckinsRx(), (value) {
        if (value.error != null && loginController.getLoginState().value == true) {
          Get.snackbar("Error", value.error.toString(),
              backgroundColor: Colors.red);
          _analyticsUseCase.execute("get_login_state_error",
              {'error': value.error, 'page': 'checkin'});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListerFlow(
      pageTitle: "Check-ins",
      listerRegistrationController: widget.listerRegistrationController,
      listerFlowController: widget.listerFlowController,
      analyticsUseCase: widget.analyticsUseCase,
      // This is where you give you custom widget it's data.
      body: Obx(
        () => controller.isLoading()
            ? const Center(
                child: CircularProgressIndicator(
                value: null,
                semanticsLabel: 'Circular progress indicator',
              ))
            : ListView(
                children: getRows(),
              ),
      ),
    );
  }

  List<Widget> getRows() {
    return [
      Container(
        height: 20,
      ),
      ...controller.getCheckins().map<Widget>((item) {
        return getTableRow(item);
      }).toList()
    ];
  }

  Widget getTableRow(Visitor item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.black45),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const SizedBox(
                    width: 70,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0, 0, 8),
                      child: Text('Name:', textAlign: TextAlign.start),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 8),
                    child: Text(
                      item.name,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 70,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0, 0, 8),
                      child: Text('Surname:', textAlign: TextAlign.start),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 8),
                    child: Text(
                      item.lastName,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 70,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0, 0, 8),
                      child: Text('Email:', textAlign: TextAlign.start),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 8),
                    child: Text(
                      item.email,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 70,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0, 0, 8),
                      child: Text('Phone:', textAlign: TextAlign.start),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 8),
                    child: Text(
                      item.phone,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    getCheckinsSubscription.dispose();
    super.dispose();
  }
}
