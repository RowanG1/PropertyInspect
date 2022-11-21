class Constants {
  // Environment
  static const stagingEnv = "staging";
  static const prodEnv = "prod";
  static const unitTestEnv = "unitTest";

  static const loggedInAnalytics = "logged_in";

  //Routing
  static const signInRoute = '/signin';
  static const homeRoute = '/home';
  static const listingBaseRoute = '/listing';
  static const listingRoute = '$listingBaseRoute/:id';
  static const userRegistrationRoute = '/userRegistration';
  static const createListingRoute = '/createListing';
  static const listingsRoute = '/listings';
  static const checkinBaseRoute = '/checkin';
  static const checkinsBaseRoute = '/checkins';
  static const checkinsRoute = '$checkinsBaseRoute/:id';
  static const checkinRoute = '$checkinBaseRoute/:id';
  static const continueToRouteKey = "continueToRoute";
  static const privacyPolicyRouteKey = "/privacyPolicy";

  //Padding
  static final largePadding = 32.toDouble();

// Text strings
  static const contactEmail= "info@property-checkin.com.au";
  static const visitorRegistrationHeading = 'Please complete your registration.';
  static const listerRegistrationHeading = 'Please complete your registration'
      '.';
  static const createListingHeading = 'Please complete your listing form.';
  static const nameLabel = 'Enter your first name';
  static const lastNameLabel = 'Enter your family name';
  static const phoneLabel = 'Enter your phone';
  static const emailLabel = 'Enter your email';
  static const suburbLabel = 'Enter your home suburb';
  static const suburbListingLabel = 'Enter the suburb';
  static const submitLabel = 'Submit';
  static const addressLabel = 'Enter the address';
  static const postCodeLabel = 'Enter the post code';
  static const defaultValidationLabel = 'Please enter some text';
  static const emailValidationLabel = 'Please enter a valid email';
  static const privacyPolicyLabel = 'Privacy Policy';

  //Footer
  static const abnLabel = "ABN: 67863792318";
  static const contactUsLabel = "Contact us";

  // Text sizes
static final headingSize = 25.toDouble();
}
