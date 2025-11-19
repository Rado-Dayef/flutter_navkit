import 'package:flutter/material.dart';
import 'package:flutter_navkit/src/navkit_observer.dart';

/// A wrapper around [MaterialApp] with automatic support for NavKit navigation.
///
/// `NavkitMaterialApp` simplifies routing by automatically generating named routes from
/// a list of screens (`navkitRoutes`) and integrating [NavkitObserver] for
/// route tracking. It also supports all common [MaterialApp] parameters.
///
/// Example usage:
/// ```dart
/// NavkitMaterialApp(
///   home: HomeScreen(),
///   navkitRoutes: [HomeScreen(), SettingsScreen()],
///   theme: ThemeData.light(),
///   darkTheme: ThemeData.dark(),
/// )
/// ```
class NavkitMaterialApp extends StatelessWidget {
  /// The default home screen of the app.
  final Widget? home;

  /// Primary color for the app.
  final Color? color;

  /// App title (used if [onGenerateTitle] is not provided).
  final String? title;

  /// The app's locale.
  final Locale? locale;

  /// The theme mode for the app.
  final ThemeMode? themeMode;

  /// Initial route when the app starts.
  final String? initialRoute;

  /// Whether to include the route stack in [NavkitObserver] debugging.
  final bool? observeWithStack;

  /// List of screens to automatically generate named routes for.
  ///
  /// The first screen in the list is assigned `/` by default.
  final List<Widget>? navkitRoutes;

  /// Curve used for theme animation transitions.
  final Curve? themeAnimationCurve;

  /// Restoration scope ID for state restoration.
  final String? restorationScopeId;

  /// Custom scroll behavior.
  final ScrollBehavior? scrollBehavior;

  /// Duration for theme animation transitions.
  final Duration? themeAnimationDuration;

  /// Supported locales for the app.
  final Iterable<Locale>? supportedLocales;

  /// Custom actions for the app.
  final Map<Type, Action<Intent>>? actions;

  /// Animation style for theme changes.
  final AnimationStyle? themeAnimationStyle;

  /// Navigator key for custom navigation control.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Shortcuts for the app.
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// Additional navigator observers.
  final List<NavigatorObserver>? navigatorObservers;

  /// Callback to generate the app title dynamically.
  final String Function(BuildContext)? onGenerateTitle;

  /// Custom builder for the app.
  final Widget Function(BuildContext, Widget?)? builder;

  /// Custom route table (ignored if [navkitRoutes] is provided).
  final Map<String, Widget Function(BuildContext)>? routes;

  /// Key for the [ScaffoldMessenger] (e.g., for showing snackbars).
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// Function to generate initial routes.
  final List<Route<dynamic>> Function(String)? onGenerateInitialRoutes;

  /// Callback for navigation notifications.
  final bool Function(NavigationNotification)? onNavigationNotification;

  /// Delegates for localizations.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Theme data for light, dark, and high contrast modes.
  final ThemeData? theme, darkTheme, highContrastTheme, highContrastDarkTheme;

  /// Callback to resolve locale.
  final Locale? Function(Locale?, Iterable<Locale>)? localeResolutionCallback;

  /// Callbacks for unknown or generated routes.
  final Route<dynamic>? Function(RouteSettings)? onUnknownRoute, onGenerateRoute;

  /// Callback to resolve a list of locales.
  final Locale? Function(List<Locale>?, Iterable<Locale>)? localeListResolutionCallback;

  /// Debug flags (show grid, performance overlay, banner, etc.)
  final bool? debugShowMaterialGrid, showSemanticsDebugger, showPerformanceOverlay, debugShowCheckedModeBanner, checkerboardOffscreenLayers, checkerboardRasterCacheImages;

  /// Creates a new [NavkitMaterialApp].
  const NavkitMaterialApp({
    super.key,
    this.home,
    this.color,
    this.title,
    this.theme,
    this.locale,
    this.routes,
    this.actions,
    this.builder,
    this.themeMode,
    this.darkTheme,
    this.shortcuts,
    this.navkitRoutes,
    this.initialRoute,
    this.navigatorKey,
    this.scrollBehavior,
    this.onUnknownRoute,
    this.onGenerateTitle,
    this.onGenerateRoute,
    this.observeWithStack,
    this.supportedLocales,
    this.highContrastTheme,
    this.restorationScopeId,
    this.navigatorObservers,
    this.themeAnimationCurve,
    this.themeAnimationStyle,
    this.scaffoldMessengerKey,
    this.showSemanticsDebugger,
    this.debugShowMaterialGrid,
    this.highContrastDarkTheme,
    this.themeAnimationDuration,
    this.showPerformanceOverlay,
    this.localizationsDelegates,
    this.onGenerateInitialRoutes,
    this.onNavigationNotification,
    this.localeResolutionCallback,
    this.debugShowCheckedModeBanner,
    this.checkerboardOffscreenLayers,
    this.localeListResolutionCallback,
    this.checkerboardRasterCacheImages,
  });

  @override
  Widget build(BuildContext context) {
    // Use the provided navigator observers, or an empty list if none were provided.
    final observers = navigatorObservers ?? [];

    // Check if the observers already include a NavkitObserver.
    final hasNavkit = observers.any((observer) => observer is NavkitObserver);

    // Map to hold the generated routes for MaterialApp.
    final Map<String, WidgetBuilder> appRoutes = {};

    // If the user provided navkitRoutes, generate route names automatically.
    if (navkitRoutes != null && navkitRoutes!.isNotEmpty) {
      // Keep track of screen types to avoid duplicate routes.
      final seenTypes = <Type>{};

      for (var i = 0; i < navkitRoutes!.length; i++) {
        final screen = navkitRoutes![i];

        // Skip if this screen type was already added.
        if (seenTypes.contains(screen.runtimeType)) continue;

        seenTypes.add(screen.runtimeType);

        // Generate the route name:
        // - The first screen always gets "/" (root route).
        // - Subsequent screens get "/screenNameRoute" in camelCase.
        final key = appRoutes.isEmpty
            ? "/" // first screen is root
            : "/${screen.runtimeType.toString()[0].toLowerCase()}${screen.runtimeType.toString().substring(1)}Route";

        // Add the screen to the route map.
        appRoutes[key] = (_) => screen;
      }
    } else {
      // If no navkitRoutes are provided, fallback to manually provided routes.
      appRoutes.addAll(routes ?? {});
    }

    return MaterialApp(
      home: home,
      title: title,
      color: color,
      theme: theme,
      locale: locale,
      actions: actions,
      builder: builder,
      routes: appRoutes,
      shortcuts: shortcuts,
      darkTheme: darkTheme,
      initialRoute: initialRoute,
      navigatorKey: navigatorKey,
      scrollBehavior: scrollBehavior,
      onUnknownRoute: onUnknownRoute,
      onGenerateTitle: onGenerateTitle,
      onGenerateRoute: onGenerateRoute,
      highContrastTheme: highContrastTheme,
      restorationScopeId: restorationScopeId,
      themeAnimationStyle: themeAnimationStyle,
      themeMode: themeMode ?? ThemeMode.system,
      scaffoldMessengerKey: scaffoldMessengerKey,
      highContrastDarkTheme: highContrastDarkTheme,
      localizationsDelegates: localizationsDelegates,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onNavigationNotification: onNavigationNotification,
      localeResolutionCallback: localeResolutionCallback,
      showSemanticsDebugger: showSemanticsDebugger ?? false,
      debugShowMaterialGrid: debugShowMaterialGrid ?? false,
      showPerformanceOverlay: showPerformanceOverlay ?? false,
      themeAnimationCurve: themeAnimationCurve ?? Curves.linear,
      localeListResolutionCallback: localeListResolutionCallback,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner ?? true,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers ?? false,
      supportedLocales: supportedLocales ?? <Locale>[Locale('en', 'US')],
      checkerboardRasterCacheImages: checkerboardRasterCacheImages ?? false,
      themeAnimationDuration: themeAnimationDuration ?? kThemeAnimationDuration,
      navigatorObservers: hasNavkit ? observers : [NavkitObserver(withStack: observeWithStack ?? false), ...observers],
    );
  }
}
