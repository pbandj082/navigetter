class NuggetConfiguration<T> {
  NuggetConfiguration({
    this.pathId,
    required this.uri,
    this.state,
    required this.pathParameters,
  });

  final T? pathId;
  final Uri uri;
  final Object? state;
  final Map<String, String> pathParameters;

  Map<String, String> get queryParameters => uri.queryParameters;
  String get fragment => uri.fragment;
}
