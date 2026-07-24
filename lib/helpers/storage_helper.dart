import 'package:saf/saf.dart';

class StorageHelper {
  final Saf _saf = Saf();

  Future<String?> pickDirectory() async {
    final directory = await _saf.pickDirectory(
      persistablePermission: true,
      writePermission: true,
    );

    return directory?.uri;
  }

  Future<List<String>> getPersistedDirectories() async {
    final permissions = await _saf.persistedPermissions();
    return permissions.map((permission) => permission.uri).toList();
  }

  Future<void> releaseAllPermissions() async {
    final permissions = await _saf.persistedPermissions();

    for (final permission in permissions) {
      await _saf.releasePersistedPermission(permission.uri);
    }
  }

  Future<void> clearCache() async {
    // The saf v2 API does not expose a direct clearCache() method.
    // This remains as a no-op for compatibility with the previous helper API.
  }
}
