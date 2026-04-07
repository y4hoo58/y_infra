# y_infra

A reusable Flutter infrastructure package that provides the building blocks for clean architecture Flutter applications.

## Installation

```yaml
dependencies:
  y_infra:
    path: ../y_infra  # or from pub.dev / git
```

```dart
import 'package:y_infra/y_infra.dart';
```

## Package Structure

```
lib/
├── core/           Cache, errors, logging, notifier, storage, theme
├── data/           Database (SQLite), file (CSV/JSON), network (Dio)
├── domain/         Repository with queue/dedup and cache invalidation
├── auth/           Token pair management
├── firebase/       Analytics, messaging, realtime database
├── push/           Push notifications (Awesome Notifications)
├── platform/       Permission handlers, location service
├── base_features/  CRUD, list, paginated, operation cubits + UI components
└── utils/          Formatters, generators, validators, routing
```

## Core

### Cache

In-memory cache with type-safe storage, multiple strategies, and cache invalidation.

```dart
final cache = DefaultCache();
cache.set('users', userList, type: CacheType.personal);
final users = cache.get<List<User>>('users');
cache.removeByPrefix('user_');
cache.removeAllType(CacheType.personal);
```

**Variants:** `ReadOnlyCache`, `WriteOnlyCache`, `NoCache`

### Errors

Categorized error system with automatic Dio exception mapping.

```dart
try {
  await dio.get('/endpoint');
} catch (e) {
  final error = ErrorMapper.map(e);
  print(error.category);      // ErrorCategory.network
  print(error.isRetryable);   // true
  print(error.shouldShowToUser); // true
}
```

**Error types:** `NetworkError`, `TimeoutError`, `ServerError`, `UnauthorisedError`, `ValidationError`, `NotFoundError`, `ConflictError`, `RateLimitError`, `UnexpectedError`

### Storage

Unified `ILocalStorage` interface with `SecureStorage` and `SharedPreferencesStorage` implementations.

```dart
final storage = SecureStorage(FlutterSecureStorage());
await storage.save<String>('key', 'value');
await storage.save<Map>('data', {'nested': true});
final value = await storage.get<String>('key');
```

### Notifier

Stream-based event bus for reactive communication between layers.

```dart
final notifier = NotifierService();
notifier.listen('user_updated').listen((event) => print(event.data));
notifier.notify(key: 'user_updated', data: updatedUser);
```

### Theme

`ThemeExtension` for custom colors used across the package.

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      YInfraColors(successColor: Colors.green, warningColor: Colors.orange),
    ],
  ),
)
```

## Data

### Network

Configurable Dio setup with a composable interceptor pipeline.

```dart
final config = BaseNetworkConfig(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 15),
);
final dio = config.createDio();
```

#### BaseInterceptor

A composable interceptor that runs a list of interceptors in sequence. If any interceptor resolves or rejects, the rest are skipped.

```dart
dio.interceptors.add(
  BaseInterceptor([
    HeaderInterceptor(appVersion: '1.0.0'),
    AuthInterceptor(
      authTokenStorage: tokenStorage,
      onTokenRefresh: (refresh) => api.refreshToken(refresh),
      onAuthFailure: () => router.go('/login'),
      retryDio: Dio(), // separate Dio instance for retry
    ),
    LoggingInterceptor(),
  ]),
);
```

Interceptors run in **declaration order**:
- `onRequest`: 1st → 2nd → 3rd → Dio sends the request
- `onResponse`: 1st → 2nd → 3rd → response returned
- `onError`: 1st → 2nd → 3rd → error returned

Any interceptor can short-circuit the pipeline:
- `handler.resolve(response)` — skip remaining interceptors, return the response
- `handler.reject(error)` — skip remaining interceptors, return the error
- `handler.next(...)` — continue to the next interceptor

You can also use each interceptor standalone without `BaseInterceptor`:

```dart
dio.interceptors.addAll([
  AuthInterceptor(...),
  LoggingInterceptor(),
]);
```

#### AuthInterceptor

JWT auth with proactive token refresh, 401 retry, and concurrent refresh locking.

```dart
AuthInterceptor(
  authTokenStorage: tokenStorage,
  onTokenRefresh: (refreshToken) => api.refreshToken(refreshToken),
  onAuthFailure: () => authCubit.logout(),
  retryDio: Dio(BaseOptions(baseUrl: 'https://api.example.com')),
  skipAuthPaths: ['/login', '/register'], // paths that don't need auth
)
```

#### LoggingInterceptor

Logs requests, responses, and errors to the debug console. Only active in debug mode. Masks authorization headers and truncates long response bodies.

```dart
LoggingInterceptor()
```

### Database

SQLite abstraction with command builders and data mappers.

```dart
class UserTable extends IDatabaseTable {
  const UserTable() : super('users');

  @override
  Map<String, String> get columns => {
    'id': 'INTEGER PRIMARY KEY',
    'name': 'TEXT',
    'email': 'TEXT',
  };
}
```

### File

CSV and JSON file controllers with path providers.

```dart
final csv = CsvFileController();
final data = await csv.load('assets/data.csv');
await csv.save(DownloadPathProvider('export.csv'), converter);
```

## Domain

### Repository

Abstract repository with request deduplication, caching, and cache invalidation.

```dart
class UserRepository extends IRepository {
  Future<User> getUser(int id) => queue(
    'user_$id',
    () => api.fetchUser(id),
    cache: defaultCache,
    cacheType: CacheType.personal,
    invalidatePrefix: 'user_list',
  );
}
```

## Auth

Token pair storage with interface.

```dart
final tokenStorage = AuthTokenStorage(secureStorage);
await tokenStorage.saveTokenPair(TokenPair(
  accessToken: 'abc',
  refreshToken: 'xyz',
));
final pair = await tokenStorage.getTokenPair();
```

## Base Features

Cubit-based state management patterns for common CRUD operations.

### List

```dart
class StoresCubit extends BaseListCubit<Store> {
  @override
  Future<List<Store>> fetchItems() => repository.getStores();
}
```

### Paginated

```dart
class ProductsCubit extends FilterablePaginatedCubit<Product> {
  @override
  int getId(Product item) => item.id;

  @override
  Future<PaginatedResponse<Product>> fetchPage(int page, int pageSize) =>
    repository.getProducts(page: page, pageSize: pageSize, search: searchQuery);
}
```

### CRUD

Full create/read/update/delete with filtering and selection.

### Operation

Single operation state management (create, update, delete, toggle).

### SafeOperationMixin

Eliminates duplicated try-catch-emit patterns.

```dart
class MyFeatureCubit extends Cubit<MyState> with SafeOperationMixin<MyState> {
  Future<void> loadData() => safeExecute(
    loadingState: MyLoading(),
    operation: () => repository.getData(),
    onSuccess: (data) => MyLoaded(data),
    onError: (error) => MyError(error),
  );
}
```

### Bottom Sheet Selector

Searchable bottom sheet with cubit-based selection state.

```dart
BottomSheetSelectorFeature<City>(
  child: BottomSheetSelectorContainer(
    emptyChild: Text('Select a city'),
    childBuilder: (city) => Text(city.name),
    bottomSheet: SearchableBottomSheetList(
      itemsProvider: () => repository.getCities(),
      itemBuilder: (city) => ListTile(title: Text(city.name)),
      searchHint: 'Search...',
      searchFilter: (city, query) => city.name.toLowerCase().contains(query),
    ),
  ),
)
```

## Platform

### Permissions

```dart
final camera = CameraPermissionHandler();
if (await camera.g2g) { /* granted */ }
await camera.askPermIfNeeded();
```

**Handlers:** Camera, Location, Notification, Storage, ExternalStorage, MotionActivity

### Location

```dart
final location = LocationService(positionCacheDuration: Duration(minutes: 5));
final position = await location.position;
final stream = await location.positionStream;
```

## Utils

### Formatters

- `DateInputFormatter` -- DD/MM/YYYY input mask
- `UpperCaseInputFormatter` -- uppercase text input
- `PhoneNumberInputFormatter` -- 555 555 55 55 format
- `DateTimeFormatter` -- locale-aware date/time formatting
- `PriceFormatter` -- price, discount, range formatting

### Validators

Configurable form validators with customizable messages.

```dart
final v = Validators(
  messages: ValidatorMessages(
    required: 'Required',
    invalidEmail: 'Invalid email',
  ),
);

TextFormField(validator: v.email());
TextFormField(validator: v.password(minLength: 8));
TextFormField(validator: v.mustMatch(() => passwordController.text));
```

## License

MIT
