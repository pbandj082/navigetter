import 'package:flutter/material.dart';

class NuggetPath<T> {
  const NuggetPath({
    required this.id,
    required this.template,
    this.pathParameterRegex,
  });

  final T id;
  final String template;
  final RegExp? pathParameterRegex;

  RegExp get pathRegex {
    var source = template.replaceAllMapped(
      pathParameterRegex ?? RegExp(r'{(\w+?)}'),
      (m) {
        return '(?<${m[1]}>.+?)';
      },
    );
    if (source.endsWith('/')) {
      source = '^$source?\$';
    } else {
      source = '^$source/?\$';
    }
    return RegExp(source);
  }

  Map<String, String> generatePathParameters(String pathString) {
    final m = pathRegex.firstMatch(pathString);
    if (m == null) {
      return {};
    }
    final pathParameters = <String, String>{
      for (final groupName in m.groupNames) groupName: m.namedGroup(groupName)!,
    };
    return pathParameters;
  }
}

@Deprecated('From 0.0.2.')
abstract class NuggetRoutePath {
  NuggetRoutePath();

  String get template;

  RegExp get pathParameterRegex => RegExp(r'{(\w+?)}');

  RegExp? _pathRegex;

  RegExp get pathRegex => _pathRegex ??= generatePathRegex();

  RegExp generatePathRegex() {
    var source = template.replaceAllMapped(
      pathParameterRegex,
      (m) {
        return '(?<${m[1]}>.+?)';
      },
    );
    if (source.endsWith('/')) {
      source = '^$source?\$';
    }
    return RegExp(source);
  }

  Map<String, String> generatePathParameters(String pathString) {
    final m = pathRegex.firstMatch(pathString)!;
    final pathParameters = <String, String>{
      for (final groupName in m.groupNames) groupName: m.namedGroup(groupName)!,
    };
    return pathParameters;
  }

  Page buildPage(
    Map<String, String> pathParameters,
    Map<String, String> queryParameters,
  );
}

@Deprecated('From 0.0.2.')
class NuggetRoutePathBuilder extends NuggetRoutePath {
  NuggetRoutePathBuilder({
    required this.template,
    required this.pageBuilder,
  });

  @override
  final String template;

  final PageBuilder pageBuilder;

  @override
  Page buildPage(
    Map<String, String> pathParameters,
    Map<String, String> queryParameters,
  ) {
    return pageBuilder(pathParameters, queryParameters);
  }
}

typedef PageBuilder = Page Function(Map<String, String>, Map<String, String>);
