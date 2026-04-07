import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Base class for app routing, providing iOS, Material, and opacity page transitions.
abstract class RoutingBase {
  final GlobalKey<NavigatorState> navigatorKey;

  const RoutingBase(this.navigatorKey);

  Route generateRoute(RouteSettings settings);

  Route iosRouting(
    Widget child,
    RouteSettings settings, {
    bool isFullScreen = false,
  }) {
    return CupertinoPageRoute(
      builder: (context) => child,
      fullscreenDialog: isFullScreen,
      settings: settings,
    );
  }

  Route materialRouting(Widget child, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => child,
      settings: settings,
    );
  }

  PageRoute opacityRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, o, ___, c) => FadeTransition(
        opacity: o,
        child: c,
      ),
    );
  }
}
