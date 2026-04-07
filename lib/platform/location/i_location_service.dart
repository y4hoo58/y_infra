import 'package:geolocator/geolocator.dart';

/// Interface for obtaining and caching device location with configurable TTL.
abstract class ILocationService {
  final Duration positionCacheDuration;

  ILocationService({required this.positionCacheDuration});

  Future<Position?> get newPosition;

  Future<Stream<Position>?> get positionStream;

  DateTime? cachedPositionDate;

  Position? cachedPosition;

  Stream<Position>? cachedPositionStream;

  Future<Position?> get position;

  Future<void> init();

  Future<Stream<Position>?> initPositionStream();

  Future<bool> routeToSettings();
}
