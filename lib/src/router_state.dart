import 'package:flutter/material.dart';

import 'configuration.dart';
import 'parser.dart';
import 'path.dart';

class NuggetStateScope<T> extends InheritedNotifier<NuggetState<T>> {
  const NuggetStateScope({
    Key? key,
    required NuggetState<T> state,
    required Widget child,
  }) : super(key: key, notifier: state, child: child);

  static NuggetState of<T>(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<NuggetStateScope<T>>()!
        .widget as NuggetStateScope<T>;
    return widget.notifier as NuggetState<T>;
  }
}

class NuggetState<T> extends ChangeNotifier {
  NuggetState({
    required this.parser,
  });
  final NuggetParser<T> parser;
  NuggetConfiguration<T>? currentConfiguration;

  Future updateAndNotify(NuggetConfiguration<T> configuration) async {
    await update(configuration);
    notifyListeners();
  }

  Future update(NuggetConfiguration<T> configuration) async {
    currentConfiguration = configuration;
  }

  Future go(location, {Object? state}) async {
    final configuration = await parser.parseRouteInformation(
      RouteInformation(location: location, state: state),
    );
    await updateAndNotify(configuration);
  }
}

@Deprecated('From 0.0.2. Please use NuggetState instead.')
class NuggetRouterStateScope extends InheritedNotifier {
  const NuggetRouterStateScope({
    Key? key,
    required NuggetRouterState state,
    required Widget child,
  }) : super(key: key, notifier: state, child: child);

  static NuggetRouterState of(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<NuggetRouterStateScope>()!
        .widget as NuggetRouterStateScope;
    return widget.notifier as NuggetRouterState;
  }
}

@Deprecated('From 0.0.2. Please use NuggetState instead.')
class NuggetRouterState extends ChangeNotifier {
  NuggetRouterState({required this.paths, required this.notFoundPage});

  final List<NuggetRoutePath> paths;
  final Page notFoundPage;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  RouteInformation? currentConfiguration;
  Uri? uri;
  Map<String, String> pathParameters = {};
  List<Page> pages = [];

  Map<String, String> get queryParameters => uri?.queryParameters ?? {};
  Map<String, String> get parameters => {...pathParameters, ...queryParameters};

  Future updateAndNotify(RouteInformation configuration) async {
    await update(configuration);
    notifyListeners();
  }

  Future update(RouteInformation configuration) async {
    var page = notFoundPage;
    var newPathParameters = <String, String>{};
    final newUri = Uri.tryParse(configuration.location!);
    if (newUri != null) {
      for (final path in paths) {
        final isValidPath = path.pathRegex.hasMatch(newUri.path);
        if (isValidPath) {
          newPathParameters = path.generatePathParameters(newUri.path);
          page = path.buildPage(
            newPathParameters,
            newUri.queryParameters,
          );
        }
      }
    }
    uri = newUri;
    pathParameters = newPathParameters;
    currentConfiguration = configuration;
    pages = [page];
  }

  Future go(location, {Object? state}) async {
    final configuration = RouteInformation(location: location, state: state);
    await updateAndNotify(configuration);
  }
}
