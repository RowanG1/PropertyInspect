import 'package:property_inspect/data/di/use_case_builders.dart';
import 'package:property_inspect/ui/controllers/checkin_controller.dart';

class CheckinControllerBuilder {
  CheckinController make() {
    return CheckinController(CheckedInUseCaseBuilder().make(),
        ListingAvailableUseCaseBuilder().make(), GetLoginIdUseCaseBuilder().make());
  }
}

