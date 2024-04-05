import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUtil {
  static void call(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      AppHelper.displayAlertError("Erro ao abrir link");
    }
  }
}
