import 'package:flutter/material.dart';

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
