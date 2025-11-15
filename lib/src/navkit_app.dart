import 'package:flutter/material.dart';
import 'package:flutter_navkit/src/navkit_observer.dart';

class NavkitApp extends StatelessWidget {
  final Widget? home;
  final Color? color;
  final Locale? locale;
  final ThemeMode? themeMode;
  final List<Widget>? navkitRoutes;
  final Curve? themeAnimationCurve;
  final ScrollBehavior? scrollBehavior;
  final Duration? themeAnimationDuration;
  final Iterable<Locale>? supportedLocales;
  final Map<Type, Action<Intent>>? actions;
  final AnimationStyle? themeAnimationStyle;
  final GlobalKey<NavigatorState>? navigatorKey;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final List<NavigatorObserver>? navigatorObservers;
  final String Function(BuildContext)? onGenerateTitle;
  final String? title, initialRoute, restorationScopeId;
  final Widget Function(BuildContext, Widget?)? builder;
  final Map<String, Widget Function(BuildContext)>? routes;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final List<Route<dynamic>> Function(String)? onGenerateInitialRoutes;
  final bool Function(NavigationNotification)? onNavigationNotification;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final ThemeData? theme, darkTheme, highContrastTheme, highContrastDarkTheme;
  final Locale? Function(Locale?, Iterable<Locale>)? localeResolutionCallback;
  final Route<dynamic>? Function(RouteSettings)? onUnknownRoute, onGenerateRoute;
  final Locale? Function(List<Locale>?, Iterable<Locale>)? localeListResolutionCallback;
  final bool? observeWithStack, debugShowMaterialGrid, showSemanticsDebugger, showPerformanceOverlay, debugShowCheckedModeBanner, checkerboardOffscreenLayers, checkerboardRasterCacheImages;

  const NavkitApp({
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
    final observers = navigatorObservers ?? [];
    final hasNavkit = observers.any((observer) => observer is NavkitObserver);
    final Map<String, WidgetBuilder> appRoutes = {};
    if (navkitRoutes != null && navkitRoutes!.isNotEmpty) {
      final seenTypes = <Type>{};
      for (var i = 0; i < navkitRoutes!.length; i++) {
        final screen = navkitRoutes![i];
        if (seenTypes.contains(screen.runtimeType)) continue;
        seenTypes.add(screen.runtimeType);
        final key = appRoutes.isEmpty ? "/" : "/${screen.runtimeType.toString()[0].toLowerCase()}${screen.runtimeType.toString().substring(1)}Route";
        appRoutes[key] = (_) => screen;
      }
    } else {
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
      navigatorObservers: hasNavkit ? observers : [NavkitObserver(withStack: observeWithStack ?? true), ...observers],
    );
  }
}
