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
├── auth/           Token storage, AuthCubit, auth state management
├── firebase/       Analytics, messaging, realtime database
├── push/           Push notifications (Awesome Notifications)
├── platform/       Permission handlers, connectivity, location
├── base_features/  CRUD, list, paginated, operation cubits
├── components/     Reusable UI components (bottom sheet selector)
├── mixins/         SnackBarY, FilterableMixin
└── utils/          Formatters, generators, validators, routing, map
```

## Core

### Cache

In-memory cache with type-safe storage, TTL support, multiple strategies, and cache invalidation.

```dart
final cache = DefaultCache();
cache.set('users', userList, type: CacheType.personal, ttl: Duration(minutes: 10));
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

### Logging

Structured logging with configurable printers and log levels.

```dart
final logger = DebugLogger(printer: ConsolePrinter());
logger.info('User logged in', data: LogData(tag: 'AUTH'));
logger.error('Failed to fetch', data: LogData(tag: 'API'));
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

#### InterceptorPipeline

A composable interceptor that runs a list of interceptors in sequence. If any interceptor resolves or rejects, the rest are skipped.

```dart
dio.interceptors.add(
  InterceptorPipeline([
    AuthInterceptor(
      authTokenStorage: tokenStorage,
      onTokenRefresh: (refresh) => api.refreshToken(refresh),
      onAuthFailure: () => authCubit.logout(),
      retryDio: Dio(BaseOptions(baseUrl: 'https://api.example.com')),
      skipAuthPaths: ['/login', '/register'],
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

Each interceptor also works standalone without `InterceptorPipeline`:

```dart
dio.interceptors.addAll([
  AuthInterceptor(...),
  LoggingInterceptor(),
]);
```

#### Remote Datasource

Base class for API calls with authenticated request support.

```dart
class UserRemoteDatasource extends IRemoteDatasource {
  UserRemoteDatasource(super.authTokenStorage, super.dio);

  Future<User> getUser(int id) => doRequest(
    () async {
      final response = await dio.get('/users/$id');
      return User.fromJson(response.data);
    },
  );
}
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

Token storage, state management, and automatic auth failure handling.

### Token Storage

```dart
final tokenStorage = AuthTokenStorage(secureStorage);
await tokenStorage.saveTokenPair(TokenPair(
  accessToken: 'abc',
  refreshToken: 'xyz',
));
final pair = await tokenStorage.getTokenPair();
```

### AuthCubit

Base auth cubit that manages authentication state. Does NOT handle login — that's project-specific. Call `onAuthenticated` after a successful login.

```dart
// Setup
final authCubit = AuthCubit(
  tokenStorage: tokenStorage,
  notifier: notifierService,         // optional: listens for auth failures
  authFailureKey: 'auth_failure',    // key that AuthInterceptor notifies on
);

// On app startup
await authCubit.checkAuth();

// After successful login
final tokens = await api.login(email, password);
authCubit.onAuthenticated(tokens);

// Logout
await authCubit.logout();

// Listen to state changes
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) => switch (state) {
    Authenticated() => HomePage(),
    Unauthenticated(reason: final reason) => LoginPage(reason: reason),
    AuthLoading() => SplashScreen(),
    _ => SplashScreen(),
  },
)
```

Auth states are `base class` — extend them in your project:

```dart
class AuthenticatedWithUser extends Authenticated {
  final User user;
  const AuthenticatedWithUser(this.user);
}
```

## Base Features

Cubit-based state management patterns for common operations.

### Operation

Single async operation with automatic state management and duplicate call guard.

```dart
class DeleteItemCubit extends BaseOperationCubit<void> {
  final ItemRepository _repo;
  DeleteItemCubit(this._repo);

  Future<void> delete(int id) => execute(
    targetId: id,
    operation: () => _repo.delete(id),
  );
}
```

States: `OperationInitial` → `OperationInProgress` → `OperationSuccess<T>` / `OperationFailure`

### List

```dart
class StoresCubit extends BaseListCubit<Store> {
  final StoreRepository _repo;
  StoresCubit(this._repo);

  @override
  Future<List<Store>> fetchItems() => _repo.getStores();
}
```

### Paginated

```dart
class ProductsCubit extends PaginatedCubit<Product> {
  final ProductRepository _repo;
  ProductsCubit(this._repo);

  @override
  int getId(Product item) => item.id;

  @override
  Future<PaginatedResponse<Product>> fetchPage(int page, int pageSize) =>
    _repo.getProducts(page: page, pageSize: pageSize);
}
```

### CRUD

Full create/read/update/delete with filtering and selection.

```dart
class UsersCubit extends CrudCubit<User> {
  final UserRepository _repo;
  UsersCubit(this._repo);

  @override
  int getId(User item) => item.id;

  @override
  Future<List<User>> fetchItems() => _repo.getUsers();

  Future<void> createUser(CreateUserDto dto) => performSave(
    operation: () => _repo.create(dto),
    successMessage: 'User created',
    updateList: (user) => addToList(user),
  );

  Future<void> deleteUser(int id) => performDelete(
    operation: () => _repo.delete(id),
    id: id,
    successMessage: 'User deleted',
  );
}
```

## Mixins

### FilterableMixin

Generic filtering mixin that works with any Cubit. Adds search, sort, and filter state.

```dart
class ProductsCubit extends PaginatedCubit<Product> with FilterableMixin {
  @override
  void onFiltersChanged() => refresh();

  @override
  Future<PaginatedResponse<Product>> fetchPage(int page, int pageSize) =>
    repo.getProducts(page: page, search: searchQuery, sortBy: sortBy);
}

// Also works with BaseListCubit
class StoresCubit extends BaseListCubit<Store> with FilterableMixin {
  @override
  void onFiltersChanged() => refresh();
}
```

### SnackBarY

Mixin for displaying themed snackbars.

```dart
class MyWidget extends StatelessWidget with SnackBarY {
  void onTap(BuildContext context) {
    displaySuccessSnack(context: context, message: 'Saved!');
    displayErrorSnack(context: context, message: 'Something went wrong');
  }
}
```

## Components

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

### Connectivity

```dart
final connectivity = ConnectivityService();
final isOnline = await connectivity.isConnected;
connectivity.onStatusChange.listen((status) => print(status));
```

### Location

```dart
final location = LocationService(positionCacheDuration: Duration(minutes: 5));
final position = await location.position;
final stream = await location.positionStream;
```

## Utils

### Formatters

**Input formatters** (for `TextFormField`):
- `SeparatorInputFormatter` — configurable base for masked input
- `DateInputFormatter` — DD/MM/YYYY input mask
- `UpperCaseInputFormatter` — uppercase text input
- `PhoneNumberInputFormatter` — 555 555 55 55 format
- `CreditCardNumberInputFormatter` — card number masking
- `CardExpiryInputFormatter` — MM/YY card expiry

**Display formatters:**
- `DateTimeFormatter` — locale-aware date/time formatting
- `PriceFormatter` — price, discount, range formatting

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

### Map Launcher

Opens Apple Maps or Google Maps for a given coordinate.

```dart
final mapLauncher = MapLauncher(
  errorMessage: 'Could not open maps',
);
mapLauncher.open(context: context, latitude: 41.0, longitude: 29.0);
```

### Routing

Navigation observer for tracking route stack.

```dart
MaterialApp(
  navigatorObservers: [AppNavObserver()],
)
```

## License

MIT
