import 'package:get_storage/get_storage.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._init();

  GetStorage? _preferences;
  static CacheManager get instance => _instance;

  CacheManager._init() {
    GetStorage.init();
    GetStorage box = GetStorage();
    _preferences = box;
  }

  static init() async {
    GetStorage.init();
    GetStorage box = GetStorage();
    instance._preferences ??= box;
    return;
  }

  Future<void> clearAll() async {
    await _preferences?.erase();
  }

  Future<void> setValue(String key, dynamic value) async {
    await _preferences?.write(key.toString(), value);
  }

  dynamic getValue(String key) => _preferences?.read(key.toString());

  Future<void> clearKey(String key) async {
    await _preferences?.remove(key.toString());
  }
}
