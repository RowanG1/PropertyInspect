import 'package:property_inspect/data/types/optional.dart';
import 'package:property_inspect/domain/entities/lister.dart';
import 'package:property_inspect/domain/repository/lister_registration_repo.dart';
import 'package:property_inspect/domain/repository/login_repo.dart';
import 'package:rxdart/rxdart.dart';

class ListerRegistrationRepoTest implements ListerRegistrationRepo {
  BehaviorSubject<bool> _isRegistered = BehaviorSubject<bool>.seeded(false);

  setIsRegistered(bool value) {
    _isRegistered.value = value;
  }

  @override
  Future<void> createListerRegistration(Lister lister) async {
    _isRegistered.value = true;
    return Future<void>.value();
  }

  @override
  Stream<bool> getIsListerRegistered(String id) {
    return _isRegistered.stream;
  }
}
