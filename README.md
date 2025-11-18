# 🧭 Flutter NavKit

A powerful and elegant navigation toolkit for Flutter that simplifies routing with type-safe navigation, automatic route generation, and comprehensive navigation observability.

[![flutter_navkit 0.0.7](https://img.shields.io/badge/flutter__navkit-0.0.7-blue)](https://pub.dev/packages/flutter_navkit/install)
[![repo 0.0.7](https://img.shields.io/badge/repo-flutter__navkit-teal?logo=github&logoColor=white)](https://github.com/Rado-Dayef/flutter_navkit)

---

## ✨ Features

- 🎯 **Type-Safe Navigation** - Auto-generated route constants with IDE autocomplete
- 🔍 **Navigation Observer** - Built-in tracking with detailed logging and route stack visualization
- 🚀 **Simple API** - Clean, intuitive extension methods on `BuildContext`
- 📦 **Auto Route Generation** - Annotate widgets and generate routes automatically
- 🎨 **Zero Boilerplate** - Minimal setup, maximum productivity
- 🔄 **Route Stack Management** - Check if routes exist, pop to specific routes, and more
- 📱 **Flutter-Native** - Works seamlessly with Flutter's navigation system
- 🛡️ **Error Handling** - Built-in error logging and safe navigation fallbacks
- 🌙 **Theme Support** - Full Material Design 3 with dark mode support

---

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_navkit: ^0.0.7

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
      navkitRoutes: [
        HomeScreen(),
        ProfileScreen(),
        SettingsScreen(),
      ],
    );
  }
}
```

### Step 2: Annotate Your Screens

Add `@NavkitRoute()` to your screen widgets:

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
        child: ElevatedButton(
          onPressed: () => context.toNamed(NavkitRoutes.profileScreen),
          child: const Text('Go to Profile'),
        ),
      ),
    );
  }
}

// Regular route
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

Run the code generator:

```bash
# One-time generation
dart run build_runner build --delete-conflicting-outputs

# Or watch for changes (recommended)
dart run build_runner watch --delete-conflicting-outputs
```

This generates a file like `lib/main.navkit.dart` containing:

```dart
class NavkitRoutes {
  NavkitRoutes._();

  /// Route name for HomeScreen
  /// (Initial Route)
  static const String homeScreen = '/';

  /// Route name for ProfileScreen
  static const String profileScreen = '/profileScreenRoute';

  /// Initial Route Is HomeScreen
  static const String initial = '/';

  /// All registered routes
  static const Map<String, String> all = {
    'HomeScreen': '/',
    'ProfileScreen': '/profileScreenRoute',
  };
}
```

### Step 5: Import Generated File

Add the import to your main file:

```dart
import 'main.navkit.dart'; // Import generated routes
```

---

## 📚 Complete API Reference

### 🎯 Navigation Extensions

NavKit provides two types of navigation extensions on `BuildContext`:

#### 1️⃣ Named Navigation (Recommended)

Use these when you want type-safe navigation with auto-generated route constants:

```dart
// Push a named route
context.toNamed(NavkitRoutes.profileScreen);

// Push with arguments
context.toNamed(
  NavkitRoutes.detailsScreen,
  args: {'userId': 123, 'title': 'User Profile'},
);

// Replace current route
context.replaceWithNamed(NavkitRoutes.loginScreen);

// Pop and push (useful for login/logout flows)
context.backAndToNamed(NavkitRoutes.homeScreen);

// Push and clear entire stack
context.toNamedAndRemoveAll(NavkitRoutes.loginScreen);

// Pop to a specific route
context.backTo(NavkitRoutes.homeScreen);

// Simple pop
context.back();
context.back(result: 'some data'); // with result
```

#### 2️⃣ Direct Widget Navigation

Use these for quick navigation without named routes:

```dart
// Push a screen
context.to(ProfileScreen());

// Replace current screen
context.replaceWith(LoginScreen());

// Push and remove all previous
context.toAndRemoveAll(HomeScreen());

// Pop to first screen
context.backToFirst();

// Try to pop (returns bool)
bool didPop = await context.maybeBack();

// Check if can pop
if (context.canPop) {
  context.back();
}
```

### 📋 Method Comparison Table

| Method | Named Route | Widget-Based | Description |
|--------|------------|--------------|-------------|
| `toNamed` | ✅ | ❌ | Push named route |
| `to` | ❌ | ✅ | Push widget directly |
| `replaceWithNamed` | ✅ | ❌ | Replace with named route |
| `replaceWith` | ❌ | ✅ | Replace with widget |
| `toNamedAndRemoveAll` | ✅ | ❌ | Clear stack + push named |
| `toAndRemoveAll` | ❌ | ✅ | Clear stack + push widget |
| `backAndToNamed` | ✅ | ❌ | Pop then push named |
| `backTo` | ✅ | ❌ | Pop to specific named route |
| `backToFirst` | ❌ | ✅ | Pop to first route |
| `back` | ✅ | ✅ | Pop current route |
| `maybeBack` | ❌ | ✅ | Safe pop with bool return |
| `canPop` | ✅ | ✅ | Check if can pop |

---

## 🔍 Navigation Observer

NavKit includes a powerful observer that tracks all navigation events with beautiful console logs.

### Features:

- ✅ Tracks push, pop, replace, and remove events
- ✅ Displays route stack in debug mode
- ✅ Beautiful emoji-based logging
- ✅ Check if routes exist in the stack
- ✅ Safe navigation with built-in error handling

### Console Output Example:

```
➡️ Push → Profile (from: Home)
────────────────────────────────────
📚 Route Stack:
   • Initial
   • Home
   • Profile
────────────────────────────────────

⬅️ Pop → Profile (back to: Home)
────────────────────────────────────
📚 Route Stack:
   • Initial
   • Home
────────────────────────────────────

🔀 Replace → Login → Home
🔄 Remove → Settings
```

### Control Stack Logging:

```dart
NavkitMaterialApp(
  observeWithStack: true, // Enable stack printing (default: false)
  navkitRoutes: [...],
)
```

### Check Route Existence:

```dart
if (NavkitObserver.hasRoute('/profile')) {
  print('Profile route exists in stack');
}
```

---

## 🎨 @NavkitRoute Annotation

The `@NavkitRoute` annotation marks widgets for automatic route generation.

### Parameters:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `isInitial` | `bool` | `false` | Mark as the initial/home route (gets "/" path) |

### Usage:

```dart
// Initial route (gets "/" path)
@NavkitRoute(isInitial: true)
class HomeScreen extends StatelessWidget { }

// Regular routes (auto-generated paths)
@NavkitRoute()
class ProfileScreen extends StatelessWidget { }
// Generated: '/profileScreenRoute'

@NavkitRoute()
class SettingsScreen extends StatelessWidget { }
// Generated: '/settingsScreenRoute'
```

### Route Naming Convention:

NavKit automatically generates route names from class names:
- `HomeScreen` → `/homeScreenRoute`
- `UserProfileScreen` → `/userProfileScreenRoute`
- `SettingsPage` → `/settingsPageRoute`

**Important:** Only **ONE** route can have `isInitial: true`. If multiple routes are marked as initial, a build error will occur.

---

## 🛠️ NavkitMaterialApp

A drop-in replacement for `MaterialApp` with automatic NavKit integration.

### Key Parameters:

```dart
NavkitMaterialApp(
  // NavKit-specific
  navkitRoutes: [HomeScreen(), ProfileScreen()], // Auto-generate routes
  observeWithStack: true,                        // Enable stack logging
  
  // Standard MaterialApp parameters
  home: HomeScreen(),
  title: 'My App',
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  themeMode: ThemeMode.system,
  initialRoute: '/',
  navigatorKey: navigatorKey,
  
  // All other MaterialApp parameters supported
  locale: Locale('en', 'US'),
  supportedLocales: [Locale('en'), Locale('ar')],
  localizationsDelegates: [...],
  debugShowCheckedModeBanner: false,
  // ... and more
)
```

### How `navkitRoutes` Works:

When you provide a list of widgets to `navkitRoutes`:

1. NavKit automatically generates route names based on widget class names
2. The **first widget** gets `/` (root route) OR the one marked with `isInitial: true`
3. Other widgets get auto-generated routes like `/screenNameRoute`
4. Routes are registered in the `MaterialApp.routes` parameter

**Example:**

```dart
navkitRoutes: [
  HomeScreen(),      // → '/' (first widget is root)
  ProfileScreen(),   // → '/profileScreenRoute'
  SettingsScreen(),  // → '/settingsScreenRoute'
]
```

**With `isInitial`:**

```dart
navkitRoutes: [
  ProfileScreen(),                        // → '/profileScreenRoute'
  HomeScreen(),                           // → '/' (marked as initial)
  SettingsScreen(),                       // → '/settingsScreenRoute'
]

// In your code:
@NavkitRoute(isInitial: true)
class HomeScreen extends StatelessWidget { }
```

---

## 🔧 Passing Arguments

### Named Routes with Arguments:

```dart
// Push with arguments
context.toNamed(
  NavkitRoutes.detailsScreen,
  args: {
    'userId': 123,
    'userName': 'John Doe',
    'email': 'john@example.com',
  },
);

// Receive arguments in widget
class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final userId = args?['userId'];
    final userName = args?['userName'];
    
    return Scaffold(
      appBar: AppBar(title: Text('User: $userName')),
      body: Text('User ID: $userId'),
    );
  }
}
```

### Widget Navigation with Arguments:

Pass arguments directly through constructors:

```dart
// Push with constructor arguments
context.to(DetailsScreen(
  userId: 123,
  userName: 'John Doe',
));

// Widget with constructor
class DetailsScreen extends StatelessWidget {
  final int userId;
  final String userName;
  
  const DetailsScreen({
    required this.userId,
    required this.userName,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User: $userName')),
      body: Text('User ID: $userId'),
    );
  }
}
```

---

## 🚨 Error Handling

NavKit includes built-in error handling with `NavkitLogger`:

### Automatic Error Logging:

```dart
// If route doesn't exist
context.toNamed('/nonexistent');
// Console: 🚨 Route '/nonexistent' not found.

// If navigation fails
context.to(BrokenScreen());
// Console: 🚨 Something went wrong when navigating to "BrokenScreen".

// If trying to pop to non-existent route
context.backTo('/missing');
// Console: 🚨 Route '/missing' not found in stack.
// (Also prints current stack if observeWithStack: true)
```

### Safe Navigation:

All navigation methods return `null` on error instead of throwing exceptions:

```dart
final result = await context.toNamed('/profile');
if (result == null) {
  // Navigation failed, handle gracefully
  print('Failed to navigate');
}
```

---

## 📖 Complete Example

Here's a full working example demonstrating all features:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_navkit/flutter_navkit.dart';

// Import generated routes
import 'main.navkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavkitMaterialApp(
      title: 'NavKit Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      observeWithStack: true, // Enable stack logging
      navkitRoutes: const [
        HomeScreen(),
        ProfileScreen(),
        SettingsScreen(),
        DetailsScreen(),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// HOME SCREEN (Initial Route)
// ═══════════════════════════════════════════════════════════

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
            ElevatedButton(
              onPressed: () => context.toNamed(NavkitRoutes.profileScreen),
              child: const Text('Go to Profile (Named)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.to(const ProfileScreen()),
              child: const Text('Go to Profile (Direct)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.toNamed(
                NavkitRoutes.detailsScreen,
                args: {'title': 'Item 1', 'id': 42},
              ),
              child: const Text('Go to Details (With Args)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.toNamed(NavkitRoutes.settingsScreen),
              child: const Text('Go to Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// PROFILE SCREEN
// ═══════════════════════════════════════════════════════════

@NavkitRoute()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            const Text('John Doe', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.toNamed(NavkitRoutes.settingsScreen),
              child: const Text('Go to Settings'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.back(),
              child: const Text('Go Back'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.backTo(NavkitRoutes.homeScreen),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SETTINGS SCREEN
// ═══════════════════════════════════════════════════════════

@NavkitRoute()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => context.toNamed(NavkitRoutes.profileScreen),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => context.toNamedAndRemoveAll(NavkitRoutes.homeScreen),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// DETAILS SCREEN (Receives Arguments)
// ═══════════════════════════════════════════════════════════

@NavkitRoute()
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final title = args?['title'] ?? 'No Title';
    final id = args?['id'] ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Title: $title', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Text('ID: $id', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.back(),
              child: const Text('Go Back'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.backToFirst(),
              child: const Text('Back to First Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎯 Best Practices

### ✅ DO:

- Use `@NavkitRoute(isInitial: true)` for your home screen
- **Place the initial route first** in the `navkitRoutes` list (the screen marked with `isInitial: true` should be the first widget in the array)
- Use named navigation (`context.toNamed`) for better type safety
- Check route existence with `NavkitObserver.hasRoute()` before navigating
- Enable `observeWithStack: true` during development for better debugging
- Use `context.canPop` before calling `context.back()` to avoid errors
- Pass complex data through constructor arguments instead of route args

### ❌ DON'T:

- Don't mark multiple routes as `isInitial: true`
- Don't forget to run `dart run build_runner build` after adding new routes
- Don't use string literals for route names - use generated constants
- Don't navigate without checking if routes exist in production
- Don't pass large objects through route arguments - use state management instead

---

## 🔄 Regenerating Routes

Whenever you add, remove, or modify `@NavkitRoute` annotations, regenerate routes:

```bash
# Clean previous builds
dart run build_runner clean

# Generate new routes
dart run build_runner build --delete-conflicting-outputs

# Or watch for changes
dart run build_runner watch --delete-conflicting-outputs
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

**Add to `.gitignore`:**

```gitignore
# Generated NavKit files
*.navkit.dart
```

---

## 🐛 Troubleshooting

### Routes Not Generating?

1. Make sure you have `build.yaml` in your project root
2. Check that `build_runner` is in `dev_dependencies`
3. Verify annotations are correct: `@NavkitRoute()`
4. Run with `--verbose` flag to see detailed output:
   ```bash
   dart run build_runner build --delete-conflicting-outputs --verbose
   ```

### Navigation Not Working?

1. Check that the route is registered in `navkitRoutes`
2. Verify the generated file is imported
3. Enable `observeWithStack: true` to see navigation logs
4. Check console for error messages

### Multiple Initial Routes Error?

Only one route can have `isInitial: true`. Check all your `@NavkitRoute` annotations and ensure only one has this flag set.

### Import Errors?

Make sure to import the generated file:
```dart
import 'main.navkit.dart'; // or 'your_file.navkit.dart'
```

---

## 📝 Migration Guide

### From Named Routes:

**Before:**
```dart
Navigator.pushNamed(context, '/profile');
Navigator.pop(context);
```

**After:**
```dart
context.toNamed(NavkitRoutes.profileScreen);
context.back();
```

### From MaterialApp:

**Before:**
```dart
MaterialApp(
  routes: {
    '/': (context) => HomeScreen(),
    '/profile': (context) => ProfileScreen(),
  },
)
```

**After:**
```dart
NavkitMaterialApp(
  navkitRoutes: [
    HomeScreen(),    // Auto-generates routes
    ProfileScreen(),
  ],
)

// Mark screens with annotation
@NavkitRoute(isInitial: true)
class HomeScreen extends StatelessWidget { }
```

---

## ⭐ Show Your Support

If you find this package helpful, please give it a ⭐ on [GitHub](https://github.com/Rado-Dayef/flutter_navkit) and like it on [pub.dev](https://pub.dev/packages/flutter_navkit)!

---

Made by [Rado Dayef](https://github.com/Rado-Dayef)