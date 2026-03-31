import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../mixins/snackbar_y.dart';

class MapLauncher with SnackBarY {
  static Future<void> openInMaps({
    required BuildContext context,
    required double latitude,
    required double longitude,
  }) async {
    final launcher = MapLauncher();
    final appleMapsUrl = Uri.parse(
      'http://maps.apple.com/?ll=$latitude,$longitude&q=Konum',
    );
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    try {
      if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          launcher.displayErrorSnack(
            context: context,
            message: 'Harita uygulaması açılamadı',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        launcher.displayErrorSnack(
          context: context,
          message: 'Harita uygulaması açılamadı',
        );
      }
    }
  }
}
