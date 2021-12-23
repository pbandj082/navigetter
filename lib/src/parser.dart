import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './configuration.dart';
import './path.dart';

class NuggetParser<T> extends RouteInformationParser<NuggetConfiguration<T>> {
  const NuggetParser({
    this.paths = const [],
  });

  final List<NuggetPath<T>> paths;

  @override
  Future<NuggetConfiguration<T>> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    final uri = Uri.parse(routeInformation.location!);
    NuggetPath? matchedPath;
    for (final path in paths) {
      final matched = path.pathRegex.hasMatch(uri.path);
      if (matched) {
        matchedPath = path;
        break;
      }
    }
    final pathParameters = matchedPath?.generatePathParameters(uri.path) ?? {};
    final configuration = NuggetConfiguration<T>(
      pathId: matchedPath?.id,
      uri: uri,
      state: routeInformation.state,
      pathParameters: pathParameters,
    );
    return SynchronousFuture(configuration);
  }

  @override
  RouteInformation? restoreRouteInformation(
    NuggetConfiguration<T> configuration,
  ) {
    return RouteInformation(
      location: configuration.uri.toString(),
      state: configuration.state,
    );
  }
}
