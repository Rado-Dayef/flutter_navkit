# 🧭 Flutter NavKit

A powerful and elegant navigation toolkit for Flutter that simplifies routing with type-safe navigation, automatic route generation, and comprehensive navigation observability.

[![flutter_navkit 1.0.2](https://img.shields.io/badge/flutter__navkit-1.0.2-blue)](https://pub.dev/packages/flutter_navkit/install)
[![repo 1.0.2](https://img.shields.io/badge/repo-flutter__navkit-teal?logo=github&logoColor=white)](https://github.com/Rado-Dayef/flutter_navkit)

---

## ✨ Features

- 🎯 **Type-Safe Navigation** - Auto-generated route constants with IDE autocomplete
- 🔍 **Navigation Observer** - Built-in tracking with detailed logging and route stack visualization
- 🚀 **Simple Extensions** - Clean, intuitive extension methods on `BuildContext`
- 📦 **Auto Route Generation** - Annotate widgets and generate routes automatically
- 🎨 **Custom Transitions** - Built-in fade, slide, and scale animations
- 🎭 **UI Helpers** - Show sheets, dialogs, and snackbars with ease
- 🔄 **Stack Management** - Check routes, pop multiple screens, navigate safely
- 🛡️ **Error Handling** - Built-in error logging with safe navigation fallbacks
- 📱 **Flutter-Native** - Works seamlessly with Flutter's navigation system

---

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_navkit: ^1.0.2

dev_dependencies:
  build_runner: ^2.4.13
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Quick Start

### Step 1: Setup Your App

Replace `MaterialApp` with `NavkitMaterialApp`:

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
    return NavkitMaterialApp(
      title: 'My App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      observeWithStack: true, // Enable debug logging
      navkitRoutes: const [
        HomeScreen(),    // Must be first if marked as initial!
        ProfileScreen(),
        SettingsScreen(),
      ],
    );
  }
}
```

### Step 2: Annotate Your Screens

```dart
import 'package:flutter/material.dart';
import 'package:flutter_navkit/flutter_navkit.dart';

// Mark as initial/home route
@NavkitRoute(isInitial: true)
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
            // Named navigation (recommended)
            ElevatedButton(
              onPressed: () => context.toNamed(NavkitRoutes.profileScreen),
              child: const Text('Go to Profile (Named)'),
            ),

            // Direct widget navigation
            ElevatedButton(
              onPressed: () => context.to(const ProfileScreen()),
              child: const Text('Go to Profile (Direct)'),
            ),

            // With fade animation
            ElevatedButton(
              onPressed: () => context.toWithFade(const SettingsScreen()),
              child: const Text('Go to Settings (Fade)'),
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
          onPressed: () => context.back(),
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}
```

### Step 3: Create `build.yaml`

Create a `build.yaml` file in your project root:

```yaml
targets:
  $default:
    builders:
      flutter_navkit|navkit_routes_builder:
        enabled: true
```

### Step 4: Generate Routes

```bash
# One-time generation
dart run build_runner build --delete-conflicting-outputs

# Or watch for changes (recommended during development)
dart run build_runner watch --delete-conflicting-outputs
```

This generates `lib/main.navkit.dart`:

```dart
class NavkitRoutes {
  NavkitRoutes._();

  /// Route name for HomeScreen
  static const String homeScreen = '/';

  /// Route name for ProfileScreen
  static const String profileScreen = '/profileScreenRoute';

  /// All registered routes
  static const Map<String, String> all = {
    'HomeScreen': '/',
    'ProfileScreen': '/profileScreenRoute',
  };
}
```

### Step 5: Import Generated File

```dart
import 'main.navkit.dart'; // Import generated routes
```

**That's it!** 🎉 You're ready to navigate!

---

## 🎯 Core Concepts

### Route Generation

Routes are auto-generated from class names:

```dart
@NavkitRoute()
class ProfileScreen extends StatelessWidget {}
// Generated: NavkitRoutes.profileScreen → '/profileScreenRoute'

@NavkitRoute(isInitial: true)
class HomeScreen extends StatelessWidget {}
// Generated: NavkitRoutes.homeScreen → '/' (root route)
```

---

## 1️⃣ Named Navigation Extension

Type-safe navigation using generated route constants.

### Methods:

```dart
/// Push a named route
context.toNamed(NavkitRoutes.profileScreen);
context.toNamed(NavkitRoutes.profileScreen, args: {'userId': 123});

/// Replace current route
context.replaceWithNamed(NavkitRoutes.loginScreen);

/// Pop and push
context.backAndToNamed(NavkitRoutes.homeScreen);

/// Push and clear stack
context.toNamedAndRemoveAll(NavkitRoutes.loginScreen);

/// Pop to specific route
context.backToNamed(NavkitRoutes.homeScreen);

/// Ensure on route (navigate if not in stack, pop to it if exists)
context.ensureOnRoute(NavkitRoutes.settingsScreen);

/// Remove specific route from stack
context.removeRouteByName(NavkitRoutes.oldScreen);
```

### Getters:

```dart
// Check if route exists in stack
bool exists = context.canPopToNamed(NavkitRoutes.profile);

// Check if current route matches
bool isCurrent = context.isCurrentRoute(NavkitRoutes.home);

// Check if route is anywhere in stack
bool inStack = context.isRouteInStack(NavkitRoutes.settings);

// Get stack length
int length = context.stackLength;

// Check if first route
bool isFirst = context.isFirstRoute;

// Check if current route can pop
bool canPop = context.canPopRoute;

// Get current route name
String? name = context.currentRouteName;
```

---

## 2️⃣ Direct Widget Navigation Extension

Navigate using widget instances directly (no route names needed).

### Methods:

```dart
/// Push a screen
context.to(ProfileScreen());

/// Replace current screen
context.replaceWith(LoginScreen());

/// Push and remove all previous
context.toAndRemoveAll(HomeScreen());
```

**Note:** Direct widget navigation automatically sets the route name to `/${WidgetType}` for logging purposes.

---

## 3️⃣ Shared Navigation Extension

Common navigation utilities available everywhere.

### Pop Methods:

```dart
/// Simple pop
context.back();
context.back(result: 'some data');

/// Pop to first route
context.backToFirst();

/// Pop multiple screens
context.backMultiple(3); // Pop 3 screens

/// Pop until condition
context.backUntil(predicate: (route) => route.settings.name == '/home');

/// Safe pop (returns bool)
bool didPop = await context.maybeBack();
bool didPop = await context.maybeBack(result: 'data');
```

### UI Helpers:

```dart
/// Show bottom sheet
context.showSheet<String>(
builder: (context) => Container(
height: 300,
child: Center(child: Text('Bottom Sheet')),
),
enableDrag: true,
isScrollControlled: true,
);

/// Show dialog
context.showAppDialog<bool>(
builder: (context) => AlertDialog(
title: const Text('Confirm'),
content: const Text('Are you sure?'),
actions: [
TextButton(
onPressed: () => context.back(result: false),
child: const Text('Cancel'),
),
TextButton(
onPressed: () => context.back(result: true),
child: const Text('OK'),
),
],
),
);

/// Show snackbar
context.showSnackBar(
content: const Text('Action completed!'),
action: SnackBarAction(
label: 'UNDO',
onPressed: () {},
),
duration: const Duration(seconds: 3),
);
```

### Argument Helpers:

```dart
/// Check if has arguments of type
if (context.hasArguments<Map<String, dynamic>>()) {
final args = context.arguments<Map<String, dynamic>>();
print('User ID: ${args?['userId']}');
}
```

### Getters:

```dart
// Can navigator pop?
bool canPop = context.canPop;
```

---

## 4️⃣ Animated Transitions Extension

Custom page transition animations.

### Methods:

```dart
/// Custom transition
context.toWithTransition(
ProfileScreen(),
transitionDuration: const Duration(milliseconds: 500),
transitionsBuilder: (context, animation, secondaryAnimation, child) {
return RotationTransition(
turns: animation,
child: child,
);
},
);

/// Fade transition
context.toWithFade(SettingsScreen());

/// Slide transition (from right)
context.toWithSlide(ProfileScreen());

/// Scale transition
context.toWithScale(DetailsScreen());
```

---

## 🔍 Navigation Observer

NavKit includes a powerful observer that tracks all navigation events with beautiful console logs.

### Features:

- ✅ Tracks push, pop, replace, and remove events
- ✅ Displays route stack in debug mode
- ✅ Check if routes exist in the stack
- ✅ Access to full navigation history

### Console Output:

```
➡️ Push → ProfileScreen (from: HomeScreen)
────────────────────────────────────
📚 Route Stack:
   • Initial
   • HomeScreen
   • ProfileScreen
────────────────────────────────────

⬅️ Pop → ProfileScreen (back to: HomeScreen)
────────────────────────────────────
📚 Route Stack:
   • Initial
   • HomeScreen
────────────────────────────────────

🔀 Replace → LoginScreen → HomeScreen

🔄 Remove → SettingsScreen
```

### Enable Stack Logging:

```dart
NavkitMaterialApp(
observeWithStack: true, // Show route stack after each navigation
navkitRoutes: [...],
)
```

### Check Route Existence:

```dart
if (NavkitObserver.hasRoute('/profile')) {
print('Profile route exists in stack');
}

// Access routes list
List<Route> routes = NavkitObserver.routes;
print('Total routes: ${routes.length}');
```

---

## 🎨 @NavkitRoute Annotation

Mark widgets for automatic route generation.

### Parameters:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `isInitial` | `bool` | `false` | Mark as the initial/home route (gets "/" path) |

### Usage:

```dart
// Initial route (root)
@NavkitRoute(isInitial: true)
class HomeScreen extends StatelessWidget {}
// Generated: NavkitRoutes.homeScreen → '/'

// Regular routes
@NavkitRoute()
class ProfileScreen extends StatelessWidget {}
// Generated: NavkitRoutes.profileScreen → '/profileScreenRoute'
```

### Rules:

- ⚠️ **Only ONE route can have `isInitial: true`**
- ⚠️ **The initial route must be FIRST** in the `navkitRoutes` list
- ✅ Route names are auto-generated from class names
- ✅ Class name `HomeScreen` → generates `homeScreen` constant

### Naming Convention:

```dart
HomeScreen → homeScreen → '/homeScreenRoute'
ProfileScreen → profileScreen → '/profileScreenRoute'
```

---

## 🛠️ NavkitMaterialApp

A drop-in replacement for `MaterialApp` with automatic NavKit integration.

### Key Parameters:

```dart
NavkitMaterialApp(
// NavKit-specific
navkitRoutes: const [        // Auto-generate routes from widgets
HomeScreen(),
ProfileScreen(),
],
observeWithStack: true,      // Enable stack logging (default: false)

// Standard MaterialApp parameters
home: const HomeScreen(),
title: 'My App',
theme: ThemeData.light(),
darkTheme: ThemeData.dark(),
themeMode: ThemeMode.system,
initialRoute: '/',
navigatorKey: navigatorKey,
navigatorObservers: [...],

// All other MaterialApp parameters supported
locale: const Locale('en', 'US'),
supportedLocales: const [Locale('en'), Locale('ar')],
localizationsDelegates: [...],
debugShowCheckedModeBanner: false,
// ... and more
)
```

### How `navkitRoutes` Works:

When you provide widgets to `navkitRoutes`:

1. NavKit generates route names from class names
2. The route marked with `isInitial: true` gets `/` (root)
3. Others get auto-generated routes like `/screenNameRoute`
4. Routes are registered in `MaterialApp.routes`

**Example:**

```dart
navkitRoutes: const [
HomeScreen(),      // Must be first if marked with isInitial: true
ProfileScreen(),   // → '/profileScreenRoute'
]
```

**Important:** The widget marked with `@NavkitRoute(isInitial: true)` **MUST be the first** in the `navkitRoutes` list!

---

## 🎯 Best Practices

### ✅ DO:

- **Use `@NavkitRoute(isInitial: true)` for your home screen**
- **Place the initial route FIRST** in the `navkitRoutes` list
- **Use named navigation** (`context.toNamed`) for better type safety
- **Check route existence** with `Observer.hasRoute()` or `context.canPopToNamed()` before navigating
- **Enable `observeWithStack: true`** during development for better debugging
- **Use `context.canPop`** before calling `context.back()` to avoid errors
- **Pass complex data** through constructor arguments instead of route args
- **Run code generator** after adding/removing `@NavkitRoute` annotations
- **Use typed argument helpers** like `context.arguments<T>()` for type safety
- **Handle navigation results** with null checks

### ❌ DON'T:

- **Don't mark multiple routes** as `isInitial: true`
- **Don't forget to run** `dart run build_runner build` after adding new routes
- **Don't use string literals** for route names - use generated constants
- **Don't navigate without checking** if routes exist in production
- **Don't pass large objects** through route arguments - use state management
- **Don't ignore the order** - initial route must be first in `navkitRoutes`
- **Don't forget to import** the generated `.navkit.dart` file

---

## 🔄 Regenerating Routes

Whenever you add, remove, or modify `@NavkitRoute` annotations:

```bash
# Clean previous builds
dart run build_runner clean

# Generate new routes
dart run build_runner build --delete-conflicting-outputs

# Or watch for changes (recommended during development)
dart run build_runner watch --delete-conflicting-outputs

# With verbose output for debugging
dart run build_runner build --delete-conflicting-outputs --verbose
```

### What Gets Generated:

For each file with `@NavkitRoute` annotations, a corresponding `.navkit.dart` file is created:

```
lib/
├── main.dart
├── main.navkit.dart           ← Generated
├── screens/
│   ├── home_screen.dart
│   ├── home_screen.navkit.dart    ← Generated
│   ├── profile_screen.dart
│   └── profile_screen.navkit.dart ← Generated
```

### Add to `.gitignore`:

```gitignore
# Generated NavKit files
*.navkit.dart
```

---

## 🐛 Troubleshooting

### Routes Not Generating?

**Problem:** Code generator doesn't create `.navkit.dart` files.

**Solutions:**
1. Ensure `build.yaml` exists in project root
2. Check that `build_runner` is in `dev_dependencies`
3. Verify annotations are correct: `@NavkitRoute()`
4. Run with verbose flag:
   ```bash
   dart run build_runner build --delete-conflicting-outputs --verbose
   ```
5. Clean and rebuild:
   ```bash
   dart run build_runner clean
   dart run build_runner build --delete-conflicting-outputs
   ```

### Navigation Not Working?

**Problem:** Navigation methods fail silently or crash.

**Solutions:**
1. Check that the route is registered in `navkitRoutes`
2. Verify the generated file is imported: `import 'main.navkit.dart';`
3. Enable `observeWithStack: true` to see navigation logs
4. Check console for error messages
5. Ensure you're using the correct route constant: `NavkitRoutes.screenName`

### Multiple Initial Routes Error?

**Problem:** Build fails with "Multiple routes marked as initial" error.

**Solution:** Only one route can have `isInitial: true`. Check all your `@NavkitRoute` annotations and ensure only one has this flag set.

```dart
// ❌ Wrong - Multiple initial routes
@NavkitRoute(isInitial: true)
class HomeScreen extends StatelessWidget {}

@NavkitRoute(isInitial: true)  // ERROR!
class WelcomeScreen extends StatelessWidget {}

// ✅ Correct - Only one initial route
@NavkitRoute(isInitial: true)
class HomeScreen extends StatelessWidget {}

@NavkitRoute()
class WelcomeScreen extends StatelessWidget {}
```

### Import Errors?

**Problem:** Cannot find `NavkitRoutes` or generated file.

**Solution:** Make sure to import the generated file:
```dart
import 'main.navkit.dart'; // or 'your_file.navkit.dart'
```

### Stack Not Showing in Logs?

**Problem:** Navigation logs appear but stack doesn't print.

**Solution:** Enable stack logging:
```dart
NavkitMaterialApp(
observeWithStack: true,  // Set to true
navkitRoutes: [...],
)
```

### Route Order Issues?

**Problem:** Initial route not working or wrong route is displayed first.

**Solution:** Ensure the route marked with `isInitial: true` is **first** in the `navkitRoutes` list:

```dart
// ❌ Wrong - Initial route not first
navkitRoutes: [
ProfileScreen(),
HomeScreen(),  // marked with isInitial: true but not first
]

// ✅ Correct - Initial route is first
navkitRoutes: [
HomeScreen(),  // marked with isInitial: true and is first
ProfileScreen(),
]
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📬 Support & Contact

- 📦 **Package**: [pub.dev](https://pub.dev/packages/flutter_navkit)
- 🐛 **Issues**: [Report a bug](https://github.com/Rado-Dayef/flutter_navkit/issues)

---

## 📊 Package Stats

- 📦 **Version**: 1.0.2
- ⭐ **GitHub**: [flutter_navkit](https://github.com/Rado-Dayef/flutter_navkit)
- 📱 **Platforms**: iOS, Android, Web, Desktop

---

## ⭐ Show Your Support

If you find this package helpful:
- 👍 **Like** it on [pub.dev](https://pub.dev/packages/flutter_navkit)
- ⭐ **Star** the repo on [GitHub](https://github.com/Rado-Dayef/flutter_navkit)
- 📢 **Share** with the Flutter community
- 🐛 **Report issues** to help improve the package

---

Made by [Rado Dayef](https://github.com/Rado-Dayef)

**Happy Navigating! 🚀**