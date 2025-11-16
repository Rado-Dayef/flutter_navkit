# 🧭 Flutter NavKit

A powerful and elegant navigation toolkit for Flutter that simplifies routing with type-safe navigation, automatic route generation, and comprehensive navigation observability.

[![flutter_navkit 0.0.2](https://img.shields.io/badge/flutter__navkit-0.0.2-blue)](https://pub.dev/packages/flutter_navkit/install)
[![repo 0.0.2](https://img.shields.io/badge/repo-flutter__navkit-teal?logo=github&logoColor=white)](https://github.com/Rado-Dayef/flutter_navkit)

## ✨ Features

- 🎯 **Type-Safe Navigation** - Auto-generated route constants with IDE autocomplete
- 🔍 **Navigation Observer** - Built-in tracking with detailed logging and route stack visualization
- 🚀 **Simple API** - Clean, intuitive extension methods on `BuildContext`
- 📦 **Auto Route Generation** - Annotate widgets and generate routes automatically
- 🎨 **Zero Boilerplate** - Minimal setup, maximum productivity
- 🔄 **Route Stack Management** - Check if routes exist, pop to specific routes, and more
- 📱 **Flutter-Native** - Works seamlessly with Flutter's navigation system

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_navkit: ^0.0.2

dev_dependencies:
  build_runner: ^2.4.13
  source_gen: ^1.5.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### 1. Setup Your App

Replace `MaterialApp` with `NavkitApp`:

```dart
import 'package:flutter_navkit/flutter_navkit.dart';

void main() {
  runApp(
    NavkitApp(
      navkitRoutes: [
        HomeScreen(),
        ProfileScreen(),
        SettingsScreen(),
      ],
    ),
  );
}
```

### 2. Annotate Your Screens

Add `@NavkitRoute()` to your screen widgets:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_navkit/flutter_navkit.dart';

@NavkitRoute()
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.pushRoute(NavkitRoutes.profileScreen),
          child: Text('Go to Profile'),
        ),
      ),
    );
  }
}

@NavkitRoute(routeName: '/custom-profile')
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.pop(),
          child: Text('Go Back'),
        ),
      ),
    );
  }
}
```

### 3. Generate Routes

Run the code generator:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch for changes:

```bash
flutter pub run build_runner watch
```

### 4. Navigate!

Use the generated `NavkitRoutes` class:

```dart
// Push a route
context.pushRoute(NavkitRoutes.profileScreen);

// Pop back
context.pop();

// Push and remove all previous routes
context.pushAndRemoveAllRoute(NavkitRoutes.homeScreen);

// Pop to a specific route
context.popTo(NavkitRoutes.homeScreen);
```

## 📚 API Reference

### Navigation Extensions

#### Normal Navigation (Widget-Based)

```dart
// Push a new screen
context.push(ProfileScreen());

// Push and replace current screen
context.pushReplacementTo(SettingsScreen());

// Push and clear entire stack
context.pushAndRemoveAll(HomeScreen());

// Pop current screen
context.pop();

// Pop with result
context.pop('result data');

// Pop to first screen
context.popToFirst();

// Check if can pop
if (context.canPop) {
  context.pop();
}

// Try to pop (returns bool)
bool didPop = await context.maybePop();
```

#### Named Navigation (Route-Based)

```dart
// Push named route
context.pushRoute('/profile');
context.pushRoute('/profile', args: {'userId': 123});

// Push replacement
context.pushReplacementRoute('/settings');

// Pop and push
context.popAndPushRoute('/home');

// Push and remove all previous
context.pushAndRemoveAllRoute('/login');

// Pop to specific route
context.popTo('/home');

// Safe navigation (checks if route exists)
context.tryPushRoute('/profile');
context.tryPopTo('/home');
```

### NavkitObserver

The observer automatically tracks all navigation events:

```dart
// Check if a route exists in the stack
if (NavkitObserver.hasRoute('/profile')) {
  print('Profile is in the navigation stack');
}
```

#### Debug Output

In debug mode, you'll see beautiful console logs:

```
➡️ Push → Profile (from: Home)
────────────────────────────────────
📚 Route Stack:
   • Initial
   • Home
   • Profile
────────────────────────────────────
```

Control stack printing:

```dart
NavkitApp(
  observeWithStack: false, // Disable stack printing
  home: HomeScreen(),
)
```

### Custom Route Names

Override default route naming:

```dart
@NavkitRoute(routeName: '/custom-name')
class MyScreen extends StatelessWidget {
  // ...
}
```

Default naming converts `HomeScreen` → `/homeScreenRoute`

## 🎯 Advanced Usage

### Passing Arguments

```dart
// Push with arguments
context.pushRoute('/profile', args: {'userId': 123});

// Receive arguments in widget
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final userId = args?['userId'];
    
    return Scaffold(
      appBar: AppBar(title: Text('User $userId')),
    );
  }
}
```

### Custom Navigator Key

```dart
final navigatorKey = GlobalKey<NavigatorState>();

NavkitApp(
  navigatorKey: navigatorKey,
  home: HomeScreen(),
)

// Use globally
navigatorKey.currentState?.pushNamed('/profile');
```

### Multiple Observers

```dart
NavkitApp(
  navigatorObservers: [
    NavkitObserver(),
    MyCustomObserver(),
    FirebaseAnalyticsObserver(),
  ],
  home: HomeScreen(),
)
```

### Conditional Navigation

```dart
// Navigate based on authentication
if (isLoggedIn) {
  context.pushRoute(NavkitRoutes.homeScreen);
} else {
  context.pushAndRemoveAllRoute(NavkitRoutes.loginScreen);
}

// Safe navigation with existence check
context.tryPushRoute(NavkitRoutes.profileScreen);
```

## 🛠️ Configuration

### build.yaml

Create a `build.yaml` file in your project root:

```yaml
targets:
  $default:
    builders:
      flutter_navkit|navkit_routes_builder:
        enabled: true
        generate_for:
          - lib/**
```

### Custom Route Generation

The generator creates routes based on class names:

- `HomeScreen` → `NavkitRoutes.homeScreen` → `/homeScreenRoute`
- `UserProfileScreen` → `NavkitRoutes.userProfileScreen` → `/userProfileScreenRoute`

Override with custom names:

```dart
@NavkitRoute(routeName: '/home')
class HomeScreen extends StatelessWidget {
  // Now accessible as NavkitRoutes.homeScreen → '/home'
}
```

## 📝 Example

Check out the [example](example/) directory for a complete working app.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_navkit/flutter_navkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavkitApp(
      title: 'NavKit Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      navkitRoutes: [
        const HomeScreen(),
        const ProfileScreen(),
        const SettingsScreen(),
      ],
    );
  }
}

@NavkitRoute()
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.pushRoute(NavkitRoutes.profileScreen),
              child: const Text('Go to Profile'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pushRoute(NavkitRoutes.settingsScreen),
              child: const Text('Go to Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

@NavkitRoute()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.pop(),
          child: const Text('Back to Home'),
        ),
      ),
    );
  }
}

@NavkitRoute()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.popToFirst(),
          child: const Text('Back to First Screen'),
        ),
      ),
    );
  }
}
```
