import 'package:geolocator/geolocator.dart';

import '../i_location_service.dart';

/// Concrete location service using Geolocator with position caching and streaming.
class LocationService extends ILocationService {
  LocationService({required super.positionCacheDuration});

  @override
  Future<Position> get newPosition async {
    cachedPosition = await Geolocator.getCurrentPosition();
    cachedPositionDate = DateTime.now();
    return cachedPosition!;
  }

  @override
  Future<Position?> get position async {
    final cachedPositionDate = this.cachedPositionDate;
    final cachedPosition = this.cachedPosition;

    if (cachedPosition != null && cachedPositionDate != null) {
      final timeDiff = DateTime.now().difference(cachedPositionDate);
      if (timeDiff < positionCacheDuration) return cachedPosition;
    }

    this.cachedPosition = await Geolocator.getCurrentPosition();
    return this.cachedPosition;
  }

  @override
  Future<Stream<Position>?> get positionStream async {
    if (cachedPositionStream != null) return cachedPositionStream;
    return await initPositionStream();
  }

  @override
  Future<void> init() async {
    await Future.wait([
      newPosition,
      initPositionStream(),
    ]);
  }

  @override
  Future<Stream<Position>?> initPositionStream() async {
    cachedPositionStream = Geolocator.getPositionStream().asBroadcastStream();
    cachedPositionStream?.listen((data) => cachedPosition = data);
    return cachedPositionStream;
  }

  @override
  Future<bool> routeToSettings() => Geolocator.openLocationSettings();
}
