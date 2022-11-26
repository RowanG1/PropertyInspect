# Property Check-in
Flutter Web project, for doing check-ins at property inspections in Australia.

#### Setup
To fetch the packages:
In terminal, enter `flutter pub get`, or open pubspec.yaml, and click `pub get`.

Tor run:
If Using Android Studio, select `main-staging.dart` configuration, with Chrome(web) for the device. Then click run 
button. See `.run`   folder for configs.

#### Architecture
* Uses the GetX state management library. This implies the usage of streams, and Rx.
* Clean architecture- presentation/UI layer, domain layer, data layer.
  Note that the use cases are in the domain folder, although a better folder could have been `application`, to 
  distinguish the application player.
* To help with having an authenticated/registration flow, `VisitorFlow` and `ListerFlow` widgets were created. This 
  allows any particular page to be accessed, with gates in place for logging in and registering.
* Multi environment: staging (used as development) and production. See `main-staging.dart` and `main-prod.dart`, with 
  corresponding 
  `firebase_options_{env}.dart` (note the imports in `main-{env}.dart` ) files

#### Releases
* Github actions is used- see `.github` folder.
* When releasing new versions of the app, it is advisable to bump the version in pubspec. Not strictly needed, as the 
  build number is auto-incremented by CI/CD, which will cause the PWA to refresh the user's app. PWA is only active 
  on Android devices.
* To do a prod release, just merge the code into the main branch. For staging release, this is done on each push onto 
develop.

#### Tests
To run tests, right click tests folder, and click `Run tests`

To run a coverage report, enter in terminal:
1) `flutter test --coverage`
2) `genhtml coverage/lcov.info -o coverage/html`
3) `open coverage/html/index.html`

When adding tests, and mockito mocks are needed, after adding the mock configuration eg:
```
@GenerateMocks([ListingRepo, AnalyticsRepo])
void main() {
}
```
run the following command in terminal:
`flutter pub run build_runner build`
to generate the mock file for the specified classes. When importing this mock file in your tests, sometimes
auto-import does not work, so manual import is needed. Eg.
`import 'listing_widget_test.mocks.dart'`;

#### Improvements that could be made:
1) For loading/error logic in controllers, this could be placed at the repository level.
2) Avoid use cases where there is no logic. If there are only a few use cases, use a mix of repo and use case
   dependencies for controllers. While not a strict adherence to clean architecture, for a smaller application like
   this, it could be more practical.
   Eg:
   ```
   class MyController {
   MyController(this._repo1, this._useCase1);
   }
   ```

3) Resolve issue where upon selecting a checkbox in the registration forms, the keyboard opens.


#### Original App Plan
See `UserFlow.txt` for plan of app.