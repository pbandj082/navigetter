import 'package:flutter/material.dart';

import 'model.dart';
import 'parser.dart';
import 'path.dart';

class NuggetScope<T> extends InheritedNotifier<NuggetModel<T>> {
  const NuggetScope({
    Key? key,
    required NuggetModel<T> model,
    required Widget child,
  }) : super(key: key, notifier: model, child: child);
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
  _NuggetState<T> createState() => _NuggetState<T>();
}

class _NuggetState<T> extends State<Nugget<T>> {
  late final NuggetModel<T> _model;

  @override
  void initState() {
    super.initState();
    final parser = NuggetParser<T>(
      paths: widget.paths,
    );
    _model = NuggetModel<T>(parser: parser);
  }

  @override
  Widget build(BuildContext context) {
    return NuggetScope<T>(
      model: _model,
      child: widget.child,
    );
  }
}
