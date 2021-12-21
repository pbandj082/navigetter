import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NuggetRouteInformationParser
    extends RouteInformationParser<RouteInformation> {
  const NuggetRouteInformationParser();

  @override
  Future<RouteInformation> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    return SynchronousFuture(routeInformation);
  }

  @override
  RouteInformation? restoreRouteInformation(
    RouteInformation configuration,
  ) {
    return configuration;
  }
}
