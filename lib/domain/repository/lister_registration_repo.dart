import '../entities/lister.dart';

abstract class ListerRegistrationRepo {
  Future<void> createListerRegistration(Lister lister);
  Stream<bool> getIsListerRegistered(String id);
}
