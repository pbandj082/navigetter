import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './router_state.dart';

class NuggetRouterDelegate extends RouterDelegate<RouteInformation>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  NuggetRouterDelegate({required this.state}) {
    state.addListener(notifyListeners);
  }

  final NuggetRouterState state;

  @override
  GlobalKey<NavigatorState> get navigatorKey => state.navigatorKey;

  @override
  RouteInformation? get currentConfiguration => state.currentConfiguration;

  @override
  Future<void> setInitialRoutePath(RouteInformation configuration) {
    state.update(configuration);
    return SynchronousFuture(null);
  }

  @override
  Future<void> setNewRoutePath(RouteInformation configuration) async {
    await state.updateAndNotify(configuration);
  }

  @override
  Future<bool> popRoute() {
    return super.popRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: state.pages,
      onPopPage: (route, result) {
        return route.didPop(result);
      },
    );
  }
}
