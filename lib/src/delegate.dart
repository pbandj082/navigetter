import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navigetter/src/configuration.dart';

import './model.dart';

class NuggetDelegate<T> extends RouterDelegate<NuggetConfiguration<T>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  NuggetDelegate({
    required this.state,
    required this.builder,
  }) {
    state.addListener(notifyListeners);
  }

  final NuggetModel<T> state;
  final Page Function(BuildContext, NuggetConfiguration<T>) builder;

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
    final pages = [builder(context, currentConfiguration!)];
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        return route.didPop(result);
      },
    );
  }
}