# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0]

### 🎉 Initial Release

#### ✨ Features

- **NavkitApp Widget** - Drop-in replacement for MaterialApp with built-in navigation observer
- **Automatic Route Generation** - Use `@NavkitRoute()` annotation to auto-generate type-safe route constants
- **NavkitObserver** - Comprehensive navigation tracking with:
    - Route stack visualization in debug mode
    - Beautiful console logging with emojis (➡️ Push, ⬅️ Pop, 🔄 Remove, 🔀 Replace)
    - `hasRoute()` method to check if routes exist in the stack
    - Optional stack printing control via `observeWithStack` parameter

#### 🚀 Navigation Extensions

**Normal Navigation (Widget-Based):**
- `context.push()` - Push a new screen
- `context.pushReplacementTo()` - Replace current screen
- `context.pushAndRemoveAll()` - Clear stack and push
- `context.pop()` - Pop current screen
- `context.popToFirst()` - Pop to initial route
- `context.maybePop()` - Safely attempt to pop
- `context.canPop` - Check if can pop

**Named Navigation (Route-Based):**
- `context.pushRoute()` - Push named route
- `context.pushReplacementRoute()` - Replace with named route
- `context.popAndPushRoute()` - Pop and push in one action
- `context.pushAndRemoveAllRoute()` - Clear stack and push named route
- `context.popTo()` - Pop to specific named route
- `context.tryPushRoute()` - Safe push with route existence check
- `context.tryPopTo()` - Safe pop with route existence check

#### 🔧 Code Generation

- **@NavkitRoute Annotation** - Mark widgets for automatic route generation
- **Custom Route Names** - Override default naming with `routeName` parameter
- **NavkitRoutes Class** - Auto-generated static constants for all routes
- **Build Runner Integration** - Seamless integration with Flutter's build system

#### 📦 Package Structure

- `NavkitApp` - Main app widget with automatic observer injection
- `NavkitObserver` - Navigation observer for tracking and debugging
- `@NavkitRoute` - Annotation for route generation
- Extension methods on `BuildContext` for clean navigation API

#### 🎯 Developer Experience

- Type-safe navigation with IDE autocomplete
- Zero boilerplate route management
- Intuitive API matching Flutter conventions
- Comprehensive debug logging
- Full Flutter navigation system compatibility

#### 📚 Documentation

- Complete README with quick start guide
- API reference documentation
- Working example application
- Usage examples for all features
