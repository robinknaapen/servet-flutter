import 'package:hive_flutter/hive_flutter.dart';
import 'package:servet/models/settings_model.dart';

class SettingsAPI {
  Box<SettingsModel> box = Hive.box('settings');

  List<SettingsModel> get() {
    return box.values.toList();
  }

  Future<void> put(SettingsModel s) async {
    await box.put(s.host, s);
  }

  Future<void> delete(Uri host) async {
    try {
      await box.delete(host);
    } catch (_) {}
  }
}
