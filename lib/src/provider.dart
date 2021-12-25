import 'package:flutter/material.dart';

import 'model.dart';
import 'parser.dart';
import 'path.dart';

class NuggetScope<T> extends InheritedNotifier<NuggetModel<T>> {
  const NuggetScope({
    Key? key,
    required NuggetModel<T> state,
    required Widget child,
  }) : super(key: key, notifier: state, child: child);
}

class Nugget<T> extends StatefulWidget {
  const Nugget({
    Key? key,
    required this.paths,
    required this.child,
  }) : super(key: key);

  final List<NuggetPath<T>> paths;
  final Widget child;

  static NuggetModel<T> of<T>(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<NuggetScope<T>>()!
        .widget as NuggetScope<T>;
    return widget.notifier as NuggetModel<T>;
  }

  @override
  _NuggetModel createState() => _NuggetModel();
}

class _NuggetModel<T> extends State<Nugget<T>> {
  late final NuggetModel<T> _state;

  @override
  void initState() {
    super.initState();
    final parser = NuggetParser<T>(
      paths: widget.paths,
    );
    _state = NuggetModel(parser: parser);
  }

  @override
  Widget build(BuildContext context) {
    return NuggetScope<T>(
      state: _state,
      child: widget.child,
    );
  }
}
