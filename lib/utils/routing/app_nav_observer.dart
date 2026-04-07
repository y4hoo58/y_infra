import 'package:flutter/material.dart';

import 'objects/route_stack_item.dart';

/// Navigator observer that maintains an in-memory stack of visited routes.
class AppNavObserver extends NavigatorObserver {
  final navStack = <RouteStackItem>[];

  String? get lastRoute {
    if (navStack.isEmpty) return null;
    return navStack.last.name;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute != null) navStack.removeLast();
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    navStack.add(RouteStackItem.fromRoute(route));
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    if (previousRoute != null) navStack.removeLast();
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (oldRoute != null) navStack.removeLast();
    if (newRoute != null) navStack.add(RouteStackItem.fromRoute(newRoute));
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
