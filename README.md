# Changelog

All notable changes to this project will be documented in this file.

---

## [1.0.0]
### 🎉 Initial Release

#### ✨ Features
- Added `NavkitMaterialApp` — a drop-in replacement for `MaterialApp` with full NavKit integration.
- Implemented `@NavkitRoute` annotation with automatic route generation.
- Generated route constants via build_runner with IDE autocomplete support.
- Added type-safe named navigation (`context.toNamed`, `context.replaceWithNamed`, etc.).
- Added direct widget navigation (`context.to`, `context.replaceWith`, etc.).
- Included shared navigation helpers:
   - Pop utilities (`back`, `backMultiple`, `backUntil`, `maybeBack`)
   - UI helpers (bottom sheets, dialogs, snackbars)
   - Argument access (`hasArguments`, `arguments<T>`)
- Introduced animated transitions:
   - Fade
   - Slide
   - Scale
   - Custom transition builder
- Added full navigation observer with:
   - Push/pop/replace/remove logging
   - Route stack visualization
   - Route existence helpers (`hasRoute`, `routes`, etc.)
- Added route validation & error handling.
- Introduced `navkitRoutes` system for registering annotated widgets.
- Fully supports all MaterialApp parameters.
- Added developer-friendly stack debug mode (`observeWithStack`).

#### 🛠️ Developer Tooling
- Added code generator with `.navkit.dart` outputs.
- Added build.yaml builder configuration.
- Recommended `.gitignore` rules for generated files.

#### 📚 Documentation
- Comprehensive README with setup steps, code examples, and best practices.
- Added quick-start guide and usage patterns.
- Added troubleshooting section and examples.
