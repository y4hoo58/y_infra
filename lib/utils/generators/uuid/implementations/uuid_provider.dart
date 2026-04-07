import 'package:uuid/uuid.dart';

import '../../../../core/storage/i_local_storage.dart';
import '../i_uuid_provider.dart';

/// UUID provider that generates a v4 UUID on first call and caches it in local storage.
class UuidProvider extends IUuidProvider {
  final ILocalStorage _storage;

  const UuidProvider(super.localStorageKey, this._storage);

  @override
  Future<String> provide() async {
    final existing = await _storage.get<String>(localStorageKey);
    if (existing != null) return existing;

    final newUuid = const Uuid().v4();
    await _storage.save<String>(localStorageKey, newUuid);
    return newUuid;
  }
}
