# property_inspect
Flutter Web project, for doing check-ins at property inspections in Australia.

####Setup
To fetch the packages:
In terminal, enter `flutter pub get`, or open pubspec.yaml, and click `pub get`.

Tor run:
If Using Android Studio, select `main-staging.dart` configuration, with Chrome(web) for the device. Then click run 
button.

####Tests
To run tests, right click tests folder, and click `Run tests`

To run a coverage report, enter in terminal:
1) `flutter test --coverage`
2) `genhtml coverage/lcov.info -o coverage/html`
3) `open coverage/html/index.html`

####Architecture
* Uses the GetX state management library. This implies the usage of streams, and Rx.
* Clean architecture- presentation/UI layer, domain layer (mixed with application layer a.k.a use cases), data layer.
* To help with having an authenticated/registration flow, `VisitorFlow` and `ListerFlow` widgets were created. This 
  allows any particular page to be accessed, with gates in place for logging in and registering.
* Multi environment: staging and production. See `main-staging.dart` and `main-prod.dart`, with corresponding 
  `firebase_options_{env}.dart` (note the imports in `main-{env}.dart` ) files

<u>Improvements that could be made:</u>
1) For loading/error logic in controllers, this could be placed at the repository level.
2) Avoid use cases where there is no logic. If there are only a few use cases, use a mix of repo and use case 
   dependencies for controllers. 
Eg: 
`
class MyController {
MyController(this._repo1, this._use1Case1);
}
`

3) Resolve issue where upon selecting a checkbox in the registration forms, the keyboard opens.

####Releases
When releasing new versions of the app, bump the version in pubspec.
To do a prod release, just merge the code into the main branch. For staging release, this is done on each push onto 
develop.

####Original App Plan
See `UserFlow.txt` for plan of app.