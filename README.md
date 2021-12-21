## Features

This Package is simple navigation package.

and Supports

* Navigator2.0
* Query Parameters
* Path Parameters
* Single page application

## Getting started

Let's 

```shell
flutter pub get navigetter
```

## Usage

Sample:

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NuggetRouterStateProvider(
      child: AppCore(),
    );
  }
}

class NuggetRouterStateProvider extends StatefulWidget {
  const NuggetRouterStateProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _NuggetRouterStateProviderState createState() => _NuggetRouterStateProviderState();
}

class _NuggetRouterStateProviderState extends State<NuggetRouterStateProvider> {
  late final NuggetRouterState _routerState;

  @override
  void initState() {
    super.initState();
    _routerState = NuggetRouterState(
      paths: [
        LoginPath(),
        NewAccountPath(),
        PasswordReissuePath(),
      ],
      notFoundPage: NuggetPage(child: Container()),
    );
  }

  @override
  void dispose() {
    _routerState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NuggetRouterStateScope(
      state: _routerState,
      child: widget.child,
    );
  }
}

class AppCore extends StatefulWidget {
  const AppCore({Key? key}) : super(key: key);

  @override
  _AppCoreState createState() => _AppCoreState();
}

class _AppCoreState extends State<AppCore> {
  late final NuggetRouterDelegate _nuggetRouterDelegate;
  late final NuggetRouteInformationParser _nuggetRouteInformationParser;

  @override
  void initState() {
    super.initState();
    final routerState = NuggetRouterStateScope.of(context);
    _nuggetRouterDelegate = NuggetRouterDelegate(state: routerState);
    _nuggetRouteInformationParser = const NuggetRouteInformationParser();
  }

  @override
  void dispose() {
    _nuggetRouterDelegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialNugget.router(
      routerDelegate: _nuggetRouterDelegate,
      routeInformationParser: _nuggetRouteInformationParser,
    );
  }
}


class LoginPath extends NuggetRoutePath {
  LoginPath();

  @override
  String get template => '/login';

  @override
  Page buildPage(
      Map<String, String> pathParameters,
      Map<String, String> queryParameters,
      ) {
    final prompt = queryParameters['prompt'] ?? 'login';
    return MaterialPage(
      key: const ValueKey(PageKeyId.root),
      child: LoginView(
        prompt: prompt,
        key: const PageStorageKey(ViewId.login),
      ),
    );
  }
}

...
```
