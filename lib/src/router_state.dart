import 'package:flutter/material.dart';

import 'path.dart';

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
