import 'package:url_launcher/url_launcher.dart';

class EmailLink {
  void openEmailLink(String email) async {
    final mailUrl = 'mailto:$email';
    try {
      await launchUrl(Uri.parse(mailUrl));
    } catch (e) {}
  }
}
