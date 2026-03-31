## 0.0.2

- Added SeparatorInputFormatter as base class for input formatters
- Added CreditCardNumberInputFormatter
- Added CardExpiryInputFormatter
- PhoneNumberInputFormatter now extends SeparatorInputFormatter
- Added IAuthTokenStorage interface
- Restructured auth/ with implementations/ folder
- Added YInfraColors ThemeExtension for custom theme colors
- Restructured package into core/, data/, domain/, platform/, base_features/, utils/
- Removed JWT and key generators
- Updated all dependencies to latest versions
- Added .gitignore and git repository

## 0.0.1

- Initial release
- Core: cache, errors, log, notifier, storage, theme
- Data: database (SQLite), file (CSV/JSON), network (Dio interceptors, config)
- Domain: repository with queue/dedup and cache invalidation
- Auth: token pair storage with interface
- Firebase: analytics, messaging, realtime database abstractions
- Push: notification management with Awesome Notifications
- Platform: permission handlers, location service
- Base Features: CRUD, list, paginated, operation cubits + filterable mixin
- Utils: formatters, generators (UUID), validators, routing
- UI: SnackBarY mixin, MapLauncher, bottom sheet selector
