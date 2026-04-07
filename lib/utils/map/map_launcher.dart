import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../mixins/snackbar_y.dart';

/// Launches Apple Maps or Google Maps for a given coordinate, with fallback error handling.
class MapLauncher with SnackBarY {
  final Uri Function(double lat, double lng) appleMapsUrlBuilder;
  final Uri Function(double lat, double lng) googleMapsUrlBuilder;
  final String errorMessage;

  const MapLauncher({
    this.appleMapsUrlBuilder = _defaultAppleMapsUrl,
    this.googleMapsUrlBuilder = _defaultGoogleMapsUrl,
    this.errorMessage = 'Could not open maps application',
  });

  static Uri _defaultAppleMapsUrl(double lat, double lng) =>
      Uri.parse('http://maps.apple.com/?ll=$lat,$lng&q=Location');

  static Uri _defaultGoogleMapsUrl(double lat, double lng) =>
      Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

  Future<void> open({
    required BuildContext context,
    required double latitude,
    required double longitude,
  }) async {
    final appleUrl = appleMapsUrlBuilder(latitude, longitude);
    final googleUrl = googleMapsUrlBuilder(latitude, longitude);

    try {
      if (await canLaunchUrl(appleUrl)) {
        await launchUrl(appleUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(googleUrl)) {
        await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          displayErrorSnack(context: context, message: errorMessage);
        }
      }
    } catch (e) {
      if (context.mounted) {
        displayErrorSnack(context: context, message: errorMessage);
      }
    }
  }
}
