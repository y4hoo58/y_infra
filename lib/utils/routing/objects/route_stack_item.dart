import 'package:flutter/material.dart';

/// Represents a single entry in the navigation stack with route name and arguments.
class RouteStackItem {
  final String? name;
  final Object? args;

  const RouteStackItem({
    required this.name,
    required this.args,
  });

  factory RouteStackItem.fromRoute(Route route) => RouteStackItem(
        name: route.settings.name,
        args: route.settings.arguments,
      );
}
