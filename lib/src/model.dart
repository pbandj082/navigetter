import 'package:flutter/material.dart';

import 'configuration.dart';
import 'parser.dart';

class NuggetModel<T> extends ChangeNotifier {
  NuggetModel({
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
