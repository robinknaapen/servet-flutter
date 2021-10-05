import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:biometric_storage/biometric_storage.dart';

// Adapters
import 'package:servet/hive/uri.dart';
import 'package:servet/models/favorite_model.dart';
import 'package:servet/models/settings_model.dart';

class HiveInstance {
  static final HiveInstance _instance = HiveInstance._internal();
  factory HiveInstance() {
    return _instance;
  }

  HiveInstance._internal() {
    Hive.registerAdapter(UriAdapter());
    Hive.registerAdapter(SettingsModelAdapter());
    Hive.registerAdapter(FavoriteModelAdapter());
  }

  // ignore: todo
  // TODO:... Not oke I suppose

  String? key;
  Future<void> init() async {
    await Hive.initFlutter();

    CanAuthenticateResponse response =
        await BiometricStorage().canAuthenticate();

    if (response != CanAuthenticateResponse.success) {
      throw "cancer";
    }

    BiometricStorageFile store = await BiometricStorage().getStorage('key');

    key = await store.read();
    if (key != null) return;

    key = base64.encode(Hive.generateSecureKey());
    await store.write(key!);
  }

  Future<HiveAesCipher> cipher() async {
    return HiveAesCipher(base64Url.decode(key!));
  }
}
