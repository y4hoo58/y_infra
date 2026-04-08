## 0.0.5

- **BREAKING:** `CrudCubit<T>` → `CrudCubit<T, Id>` — generic ID type instead of hardcoded `int`
- **BREAKING:** `PaginatedCubit<T>` → `PaginatedCubit<T, Id>` — generic ID type instead of hardcoded `int`
- **BREAKING:** `BaseOperationCubit<TResult>` → `BaseOperationCubit<TResult, Id>` — generic ID type for `targetId`
- **BREAKING:** `EndpointResponseLogData` and `NetworkResponseLogData` now take plain fields (`statusCode`, `body`, `url`) instead of `http` `Response`
- **BREAKING:** `CrudSaved` and `CrudDeleted` now carry an `items` field; `CrudCubit` emits a single state instead of two
- Fixed `AuthInterceptor` and `IRemoteDatasource` depending on concrete `AuthTokenStorage` instead of `IAuthTokenStorage`
- Fixed `ExternalStoragePermissionHandler.g2g` checking wrong permission (`Permission.storage` vs `Permission.manageExternalStorage`)
- Fixed `AppNavObserver.didPop`/`didRemove` removing wrong routes from the navigation stack
- Fixed `EventLogData.message` throwing `UnimplementedError` — now accepts a message string
- Fixed `TokenPair` not extending `Equatable`, causing missed state changes in `AuthState`
- Added `ErrorMessages` — centralised, overridable error messages for i18n support
- Updated all error types and `ErrorMapper` to use `ErrorMessages.instance` instead of hardcoded English
- Removed `LocationService` auto-init in constructor — consumers now call `init()` explicitly
- Removed `http` package dependency (no longer needed)

## 0.0.4

- Added `InterceptorPipeline` for composable Dio interceptor chains
- Added `AuthCubit` with token check, login/logout, and auto-logout on auth failures
- Added `AuthState` hierarchy (`AuthInitial`, `AuthLoading`, `Authenticated`, `Unauthenticated`)
- Added `UnauthenticatedReason` enum (`noToken`, `sessionExpired`, `loggedOut`)
- Added `FilterableMixin` — generic filtering mixin for any Cubit (search, sort, filter)
- Improved `BaseOperationCubit` — now generic with built-in `execute()` and duplicate call guard
- Removed `SafeOperationMixin` (merged into `BaseOperationCubit`)
- Removed `FilterablePaginatedCubit` (use `PaginatedCubit with FilterableMixin` instead)
- Removed `CorrelationIdInterceptor`
- Restructured `data/network/` into `config/`, `datasource/`, `interceptors/`, `objects/`
- Restructured `utils/formatters/` into `input/` and `display/` subfolders
- Moved `token_pair.dart` to `auth/objects/`
- Moved `components/` to top-level `lib/components/`
- Moved `mixins/` to top-level `lib/mixins/`
- Moved `map_launcher` to `utils/map/` with configurable URLs and error message
- Added doc comments to all files
- Updated README with full usage examples

## 0.0.3

- Added TTL (time-to-live) support to cache system
- Added ConnectivityService for network status monitoring (connectivity_plus)

## 0.0.2

- Added SeparatorInputFormatter as configurable base for input formatters
- Added CreditCardNumberInputFormatter and CardExpiryInputFormatter
- Added IAuthTokenStorage interface
- Added YInfraColors ThemeExtension
- Restructured package into core/, data/, domain/, platform/, base_features/, utils/
- Updated all dependencies to latest versions

## 0.0.1

- Initial release
- Core: cache, errors, log, notifier, storage, theme
- Data: database (SQLite), file (CSV/JSON), network (Dio interceptors, config)
- Domain: repository with queue/dedup and cache invalidation
- Auth: token pair storage
- Firebase: analytics, messaging, realtime database abstractions
- Push: notification management with Awesome Notifications
- Platform: permission handlers, location service
- Base Features: CRUD, list, paginated, operation cubits + filterable mixin
- Utils: formatters, generators (UUID), validators, routing
- Base Features: SnackBarY mixin, MapLauncher, bottom sheet selector
