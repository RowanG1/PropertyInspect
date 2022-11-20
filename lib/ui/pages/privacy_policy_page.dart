import 'package:flutter/cupertino.dart';
import 'package:property_inspect/ui/pages/unauthenticated_page.dart';

import '../../domain/constants.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final visitorPolicy = """
We collect and store the following data from visitors at check-in: name, surname, phone, email, and home suburb.
The data is collected by way of a registration form. 
Reason for data collection: the agent of the visited property may contact you after a visit to follow up on your property journey.
Only the agent of the visited property will be given your information, and limited to the data provided at the check-in. 
If your details change after the check in, these details will not be made available to the agent.
""";

  final listerPolicy = """
The name, surname, phone and email of the lister is collected for lister registration.
For property listings, the address, suburb, post code, and agent phone number are collected.
By nature, lister information is publicly available, although in practice this is limited by physical checkins.
""";

  final otherPolicy = """
You may contact Property Check-in to modify your personal information, or to lodge a complaint.

Contact detail:
info@property-checkin.com.au

All your personal information will reside in Australia using a secure cloud provider.
""";

  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UnauthenticatedPage(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Visitors:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(visitorPolicy),
              const Text('Listers:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(listerPolicy),
              Text(otherPolicy),
            ],
          ),
        ),
      ),
      pageTitle: Constants.privacyPolicyLabel,
    );
  }
}
