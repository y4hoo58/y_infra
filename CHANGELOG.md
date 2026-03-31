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
