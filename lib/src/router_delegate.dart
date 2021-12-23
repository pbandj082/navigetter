import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navigetter/src/configuration.dart';

import './router_state.dart';

class NuggetDelegate<T> extends RouterDelegate<NuggetConfiguration<T>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  NuggetDelegate({
    required this.state,
    required this.builder,
  }) {
    state.addListener(notifyListeners);
  }

  final NuggetState<T> state;
  final Page Function(NuggetConfiguration<T>) builder;

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  NuggetConfiguration<T>? get currentConfiguration =>
      state.currentConfiguration;

  @override
  Future<void> setInitialRoutePath(NuggetConfiguration<T> configuration) {
    state.update(configuration);
    return SynchronousFuture(null);
  }

  @override
  Future<void> setNewRoutePath(NuggetConfiguration<T> configuration) async {
    await state.updateAndNotify(configuration);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [builder(currentConfiguration!)];
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        return route.didPop(result);
      },
    );
  }
}

@Deprecated('From 0.0.2. Please use NuggetDelegate instead')
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
