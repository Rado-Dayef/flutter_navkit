## [1.0.2]

### 🎉 Initial Release

> ⚠️ Note: This release was re-published because the wrong README file was uploaded in the previous attempt.  
> No code changes were made — only documentation was corrected.

#### ✨ Features

- **NavkitApp Widget** – Drop-in replacement for `MaterialApp` with built-in navigation observer.
- **Automatic Route Generation** – Use `@NavkitRoute()` annotation to auto-generate type-safe route constants.
- **NavkitObserver** – Full navigation tracking with:
  - Route stack visualization in debug mode
  - Clean console logging with emojis (➡️ Push, ⬅️ Pop, 🔄 Remove, 🔀 Replace)
  - `hasRoute()` to check existing routes in the stack
  - Optional stack printing via `observeWithStack`

#### 🚀 Navigation Extensions

**Normal Navigation (Widget-Based):**
- `context.push()`
- `context.pushReplacementTo()`
- `context.pushAndRemoveAll()`
- `context.pop()`
- `context.popToFirst()`
- `context.maybePop()`
- `context.canPop`

**Named Navigation (Route-Based):**
- `context.pushRoute()`
- `context.pushReplacementRoute()`
- `context.popAndPushRoute()`
- `context.pushAndRemoveAllRoute()`
- `context.popTo()`
- `context.tryPushRoute()`
- `context.tryPopTo()`

#### 🔧 Code Generation

- `@NavkitRoute` annotation for marking screens
- Optional `routeName` override
- Auto-generated `NavkitRoutes` class
- Full build_runner integration

#### 📦 Package Structure

- `NavkitApp` – main entry widget
- `NavkitObserver` – advanced route observer
- `@NavkitRoute` – annotation for route generation
- Navigation extensions on `BuildContext`

#### 🎯 Developer Experience

- Type-safe navigation with autocomplete
- Zero-boilerplate route management
- Intuitive API following Flutter’s patterns
- Detailed debug logging
- Fully compatible with Flutter’s Navigator 1.0

#### 📚 Documentation

- Updated README (fixed in this release)
- Full usage examples
- In-depth API explanations
- Example project included
