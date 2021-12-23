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
