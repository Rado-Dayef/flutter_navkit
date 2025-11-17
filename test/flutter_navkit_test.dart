import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_navkit/flutter_navkit.dart';

void main() {
  group('NavkitObserver Tests', () {
    test('hasRoute returns true when route exists', () {
      final observer = NavkitObserver();
      final route = MaterialPageRoute(
        builder: (_) => Container(),
        settings: RouteSettings(name: '/home'),
      );

      observer.didPush(route, null);

      expect(NavkitObserver.hasRoute('/home'), true);
      expect(NavkitObserver.hasRoute('/nonexistent'), false);
    });

    test('route is removed after pop', () {
      final observer = NavkitObserver();
      final route = MaterialPageRoute(
        builder: (_) => Container(),
        settings: RouteSettings(name: '/test'),
      );

      observer.didPush(route, null);
      expect(NavkitObserver.hasRoute('/test'), true);

      observer.didPop(route, null);
      expect(NavkitObserver.hasRoute('/test'), false);
    });

    test('route is replaced correctly', () {
      final observer = NavkitObserver();
      final oldRoute = MaterialPageRoute(
        builder: (_) => Container(),
        settings: RouteSettings(name: '/old'),
      );
      final newRoute = MaterialPageRoute(
        builder: (_) => Container(),
        settings: RouteSettings(name: '/new'),
      );

      observer.didPush(oldRoute, null);
      expect(NavkitObserver.hasRoute('/old'), true);

      observer.didReplace(oldRoute: oldRoute, newRoute: newRoute);
      expect(NavkitObserver.hasRoute('/old'), false);
      expect(NavkitObserver.hasRoute('/new'), true);
    });
  });

  group('NavkitMaterialApp Tests', () {
    testWidgets('NavkitMaterialApp builds with home widget', (tester) async {
      await tester.pumpWidget(
        NavkitMaterialApp(
          home: Scaffold(
            body: Text('Home'),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('NavkitMaterialApp generates routes from navkitRoutes', (tester) async {
      await tester.pumpWidget(
        NavkitMaterialApp(
          navkitRoutes: [
            Scaffold(key: Key('screen1'), body: Text('Screen 1')),
            Scaffold(key: Key('screen2'), body: Text('Screen 2')),
          ],
          initialRoute: '/',
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Screen 1'), findsOneWidget);
    });

    testWidgets('NavkitMaterialApp automatically adds NavkitObserver', (tester) async {
      final app = NavkitMaterialApp(
        home: Scaffold(body: Text('Test')),
      );

      await tester.pumpWidget(app);

      // Verify the app builds successfully with observer
      expect(find.text('Test'), findsOneWidget);
    });
  });

  group('Navigation Extension Tests', () {
    testWidgets('push extension works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    context.to(Scaffold(body: Text('Pushed')));
                  },
                  child: Text('Push'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Push'));
      await tester.pumpAndSettle();

      expect(find.text('Pushed'), findsOneWidget);
    });

    testWidgets('pop extension works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Text('Home')),
        ),
      );

      final context = tester.element(find.text('Home'));

      // Push a route
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => Scaffold(body: Text('Second'))),
      );
      await tester.pumpAndSettle();
      expect(find.text('Second'), findsOneWidget);

      // Pop it
      final secondContext = tester.element(find.text('Second'));
      secondContext.back();
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Second'), findsNothing);
    });

    testWidgets('canPop extension works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Column(
                  children: [
                    Text('Can pop: ${context.canPop}'),
                  ],
                ),
              );
            },
          ),
        ),
      );

      expect(find.textContaining('Can pop: false'), findsOneWidget);
    });
  });

  group('Named Navigation Extension Tests', () {
    testWidgets('pushRoute extension works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/home': (_) => Scaffold(body: Text('Home')),
            '/profile': (_) => Scaffold(body: Text('Profile')),
          },
          initialRoute: '/home',
        ),
      );

      final context = tester.element(find.text('Home'));
      context.toNamed('/profile');
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('pushReplacementRoute extension works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/home': (_) => Scaffold(body: Text('Home')),
            '/profile': (_) => Scaffold(body: Text('Profile')),
          },
          initialRoute: '/home',
        ),
      );

      final context = tester.element(find.text('Home'));
      context.replaceWithNamed('/profile');
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Home'), findsNothing);
    });
  });
}