import 'package:flutter/material.dart';
import 'package:servet/models/settings_model.dart';
import 'package:servet/services/hive/settings_api.dart';

class SettingsVM with ChangeNotifier {
  final SettingsAPI _api = SettingsAPI();

  List<SettingsViewModel> settings = List.empty();
  fetch() {
    settings = _api
        .get()
        .map(
          (e) => SettingsViewModel(e),
        )
        .toList();

    settings.sort((a, b) => a.host.host.compareTo(b.host.host));
    notifyListeners();
  }

  Future<void> put(SettingsModel s) async {
    await _api.put(s);
    fetch();
  }
}

class SettingsViewModel {
  final SettingsModel _settings;
  SettingsViewModel(this._settings);

  Uri get host {
    return _settings.host;
  }

  set host(Uri h) {
    _settings.host = h;
  }

  String? get token {
    return _settings.token;
  }

  set token(String? s) {
    _settings.token = s;
  }
}
