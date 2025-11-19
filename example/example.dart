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
        HomeScreen(),       // Must be first (marked as initial)
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'NavKit Demo',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              // Named Navigation
              ElevatedButton(
                onPressed: () => context.toNamed(NavkitRoutes.profileScreen),
                child: const Text('Go to Profile (Named)'),
              ),
              const SizedBox(height: 16),

              // Direct Widget Navigation
              ElevatedButton(
                onPressed: () => context.to(const ProfileScreen()),
                child: const Text('Go to Profile (Direct)'),
              ),
              const SizedBox(height: 16),

              // With Arguments
              ElevatedButton(
                onPressed: () => context.toNamed(
                  NavkitRoutes.detailsScreen,
                  args: {
                    'title': 'Product Details',
                    'id': 42,
                    'price': 99.99,
                  },
                ),
                child: const Text('Go to Details (With Args)'),
              ),
              const SizedBox(height: 16),

              // With Fade Animation
              ElevatedButton(
                onPressed: () => context.toWithFade(const SettingsScreen()),
                child: const Text('Go to Settings (Fade)'),
              ),
              const SizedBox(height: 16),

              // With Slide Animation
              ElevatedButton(
                onPressed: () => context.toWithSlide(const SettingsScreen()),
                child: const Text('Go to Settings (Slide)'),
              ),
              const SizedBox(height: 16),

              // Show Bottom Sheet
              ElevatedButton(
                onPressed: () => context.showSheet(
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Bottom Sheet',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('This is a modal bottom sheet!'),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.back(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ),
                child: const Text('Show Bottom Sheet'),
              ),
              const SizedBox(height: 16),

              // Show Dialog
              ElevatedButton(
                onPressed: () async {
                  final result = await context.showAppDialog<bool>(
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Action'),
                      content: const Text('Are you sure you want to proceed?'),
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

                  if (result == true) {
                    context.showSnackBar(
                      content: const Text('Action confirmed!'),
                    );
                  }
                },
                child: const Text('Show Dialog'),
              ),
            ],
          ),
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
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('john.doe@example.com'),
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
              onPressed: () => context.backToNamed(NavkitRoutes.homeScreen),
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
            subtitle: const Text('View and edit profile'),
            onTap: () => context.toNamed(NavkitRoutes.profileScreen),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Manage notifications'),
            onTap: () {
              context.showSnackBar(
                content: const Text('Notifications settings'),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle dark mode'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              context.showAppDialog(
                builder: (context) => AlertDialog(
                  title: const Text('About NavKit'),
                  content: const Text('NavKit Demo v1.0.1'),
                  actions: [
                    TextButton(
                      onPressed: () => context.back(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              context.toNamedAndRemoveAll(NavkitRoutes.homeScreen);
            },
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
    final args = context.arguments<Map<String, dynamic>>();
    final title = args?['title'] ?? 'No Title';
    final id = args?['id'] ?? 0;
    final price = args?['price'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.image, size: 80),
              ),
              const SizedBox(height: 24),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'ID: $id',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                '\${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => context.back(),
                    child: const Text('Back'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => context.backToFirst(),
                    child: const Text('Home'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}