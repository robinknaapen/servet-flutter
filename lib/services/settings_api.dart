import 'package:hive_flutter/hive_flutter.dart';
import 'package:servet/hive/hive_init.dart';
import 'package:servet/models/settings_model.dart';

class SettingsAPI {
  Future<SettingsModel> get() async {
    Box<SettingsModel> box = await Hive.openBox('settings',
        encryptionCipher: await HiveInstance().cipher());

    try {
      return box.get('settings') ?? SettingsModel();
    } catch (_) {
      return SettingsModel();
    }
  }

  Future<void> save(SettingsModel s) async {
    Box<SettingsModel> box = await Hive.openBox('settings',
        encryptionCipher: await HiveInstance().cipher());
    await box.put('settings', s);
  }
}
