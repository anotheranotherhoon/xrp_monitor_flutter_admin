# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter web admin dashboard for the XRP Monitor system. It provides administrative capabilities for managing users, keywords, versions, and monitoring system data through a web interface.

## Development Setup

### Prerequisites
- FVM (Flutter Version Manager) is used for Flutter version management
- Node.js/npm for commitlint and husky git hooks
- Git submodules may be present (initialized during setup)

### Essential Commands

**Initial Setup:**
```bash
./configure.sh              # Complete setup: submodules, clean, pub get, code generation
```

**Development Workflow:**
```bash
./code_generator.sh         # Run build_runner in watch mode (recommended during development)
fvm flutter run -d chrome --web-port 8080    # Run web app on specific port
```

**Code Generation:**
```bash
fvm dart run build_runner build --delete-conflicting-outputs   # One-time generation
fvm dart run build_runner watch --delete-conflicting-outputs   # Watch mode (preferred)
```

**Cleanup:**
```bash
./clean.sh                  # Delete all generated files (*.g.dart, *.freezed.dart, *.gr.dart)
fvm flutter clean           # Full Flutter clean
```

**Build:**
```bash
fvm flutter build web       # Production web build
```

## Architecture

### State Management & Code Generation
- **Riverpod**: Primary state management using `@riverpod` annotation for providers
- **Freezed**: All data models use Freezed for immutability and code generation
- **JSON Serialization**: `json_serializable` for API models with `@JsonSerializable()`
- **Auto Route**: Declarative routing with `@AutoRouterConfig()` and code generation

Generated files must be committed to git since they're required by the CI/CD pipeline.

### Project Structure

```
lib/
├── constants/          # App-wide constants
├── core/
│   ├── constants/      # API paths and configuration
│   │   └── api_path.dart    # Server environment config (dev/beta/prod)
│   ├── route/          # Auto Route configuration
│   │   ├── app_router.dart  # Main router with AuthGuard
│   │   └── auth_guard.dart  # Authentication guard for protected routes
│   └── services/       # Domain services (API clients)
│       ├── base/       # Base API infrastructure
│       │   ├── api_service.dart        # Dio-based HTTP client
│       │   ├── auth_interceptor.dart   # JWT token handling & refresh
│       │   └── models/                 # Response wrappers, exceptions
│       ├── user/       # User management service
│       ├── keyword/    # Keyword management service
│       └── version/    # Version management service
├── service/            # Application-level services
│   ├── authentication/ # Authentication state management
│   │   └── authentication.dart   # Session & token management provider
│   └── storage/        # Local storage wrapper
│       └── local_storage_service.dart  # SharedPreferences abstraction
├── ui/
│   ├── layout/         # Layout components
│   ├── screen/         # Feature screens (auth, dashboard, user, keyword, version)
│   ├── themes/         # Theme configuration
│   └── utils/          # UI utilities
├── utils/              # General utilities
└── widgets/            # Reusable UI components
```

### Key Architectural Patterns

**API Service Layer:**
- `ApiService` (in `core/services/base/`) provides HTTP methods via Dio
- `AuthInterceptor` automatically adds JWT tokens and handles token refresh on 401 errors
- Domain services (UserService, KeywordService, etc.) use `ApiService` and return `ResponseModel<T>`
- All services are Riverpod providers using `@riverpod` annotation

**Authentication Flow:**
- `Authentication` provider manages session state with JWT access/refresh tokens
- Tokens stored in `LocalStorageService` (SharedPreferences wrapper)
- `AuthGuard` protects routes, redirecting to `/login` if unauthenticated
- On 401 errors, `AuthInterceptor` attempts token refresh, retries request, or redirects to login

**Routing:**
- Auto Route with declarative `@AutoRouterConfig()` configuration
- Routes defined in `app_router.dart` with path, guards, and initial route
- Use `AutoRoute(page: SomeRoute.page, path: '/path', guards: authGuards)` pattern

**Models:**
- All models use Freezed: `@freezed` annotation with `copyWith`, equality, toString
- API models include `@JsonSerializable()` with `fromJson`/`toJson`
- Request/Response models follow naming: `*Request`, `*Response`, `*Model`

**Error Handling:**
- `ResponseModel<T>` wraps all service responses with success/error state
- `ResponseException` for throwing structured errors
- `ResponseType` enum: success, alert, confirm, etc.

## Environment Configuration

API endpoints are configured in `lib/core/constants/api_path.dart`:
- Three server types: dev, beta, prod (currently all point to `xrp-monitor.p-e.kr`)
- Change environment: `ApiPath.setServerType(ServerType.dev)`

## Commit Conventions

This project uses emoji-based conventional commits enforced by commitlint + husky:

```
<type>(optional scope): <subject>
```

**Required Types:**
- ✨ Feat: New features
- 🐛 Fix: Bug fixes
- ⭐️ Style: Code formatting (no logic change)
- ♻️ Refactor: Code refactoring
- 📁 File: Asset/file additions
- 🎨 Design: UI/styling changes
- 🏷 Comment: Documentation in code
- ✅ Test: Test additions/updates
- 📝 Docs: Documentation files
- 🚑 Hotfix: Critical bug fixes
- 🔥 Remove: File/code removal
- 💚 Ci: CI/CD changes
- 🔖 Release: Version releases
- 🔧 Chore: Configuration changes

**Examples:**
- `✨ Feat: 로그인 기능 추가`
- `🐛 Fix(login): 토큰 갱신 버그 수정`
- `♻️ Refactor(user): 사용자 서비스 코드 개선`

## CI/CD

GitHub Actions workflow (`.github/workflows/deploy.yml`):
1. Triggers on push to `master` branch
2. Sets up Flutter, installs dependencies
3. Runs code generation: `dart run build_runner build`
4. Builds web: `flutter build web`
5. Deploys to Oracle Cloud VM via SSH

**Important:** Code generation step is required in CI, so generated files must be committable.

## Common Patterns

**Adding a New Service:**
1. Create service directory under `lib/core/services/<domain>/`
2. Define models with `@freezed` and `@JsonSerializable()`
3. Create service class extending Riverpod's generated base with `@riverpod`
4. Use `ref.read(apiServiceProvider.notifier)` to access HTTP client
5. Return `ResponseModel<T>` from all methods
6. Run code generator

**Adding a New Screen:**
1. Create screen file with `@RoutePage()` annotation
2. Add route to `app_router.dart` routes list
3. Add `guards: authGuards` if authentication required
4. Use Riverpod hooks (`HookConsumerWidget`) for state management
5. Run code generator to update `app_router.gr.dart`

**Using Generated Providers:**
```dart
// In build method of HookConsumerWidget
final userService = ref.read(userServiceProvider.notifier);
final authState = ref.watch(authenticationProvider);
```

## Testing Credentials

Documented in README.md:
- Email: `superadmin@xrpmonitor.com`
- Password: `superadmin123`

## Important Notes

- Always use FVM: `fvm flutter` and `fvm dart` commands
- Keep code generator running in watch mode during development
- Run `./clean.sh` if encountering generation issues
- All HTTP calls go through `ApiService` with automatic auth token injection
- On API changes, regenerate with `build_runner` to update models/providers