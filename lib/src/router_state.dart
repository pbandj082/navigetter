import 'package:flutter/material.dart';

import 'configuration.dart';
import 'parser.dart';

class NuggetStateScope<T> extends InheritedNotifier<NuggetState<T>> {
  const NuggetStateScope({
    Key? key,
    required NuggetState<T> state,
    required Widget child,
  }) : super(key: key, notifier: state, child: child);

  static NuggetState<T> of<T>(BuildContext context) {
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
