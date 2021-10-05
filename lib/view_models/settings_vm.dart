import 'package:flutter/material.dart';
import 'package:servet/models/settings_model.dart';
import 'package:servet/services/settings_api.dart';

class SettingsVM with ChangeNotifier {
  final SettingsAPI _api = SettingsAPI();

  SettingsViewModel? settings;
  Future<void> get() async {
    settings = SettingsViewModel(await _api.get());

    notifyListeners();
  }

  Future<void> save(SettingsModel s) async {
    await _api.save(s);
    settings = SettingsViewModel(await _api.get());

    notifyListeners();
  }
}

class SettingsViewModel {
  final SettingsModel? _settings;
  SettingsViewModel(this._settings);

  Uri? get host {
    return _settings?.host;
  }

  set host(Uri? h) {
    _settings?.host = h;
  }

  String? get token {
    return _settings?.token;
  }

  set token(String? s) {
    _settings?.token = s;
  }
}
