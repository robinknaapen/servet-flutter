import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:biometric_storage/biometric_storage.dart';

// Boxes
// Adapters
import 'package:servet/hive/uri.dart';
import 'package:servet/models/favorite_model.dart';
import 'package:servet/models/settings_model.dart';

class HiveInstance {
  List<String> boxesToOpen = List.from([
    'settings',
    'favorites',
  ]);

  static final HiveInstance _instance = HiveInstance._internal();
  factory HiveInstance() {
    return _instance;
  }

  HiveInstance._internal() {
    Hive.registerAdapter(UriAdapter());
    Hive.registerAdapter(SettingsModelAdapter());
    Hive.registerAdapter(FavoriteModelAdapter());
  }

  Future<void> init() async {
    await Hive.initFlutter();

    BiometricStorageFile store = await _initBiometrics();
    HiveAesCipher cipher = await _initCipher(store);

    await _openBoxes(cipher);
  }

  Future<BiometricStorageFile> _initBiometrics() async {
    CanAuthenticateResponse response =
        await BiometricStorage().canAuthenticate();

    if (response != CanAuthenticateResponse.success) {
      throw "Cannot use biometrics...";
    }

    return await BiometricStorage().getStorage('key');
  }

  Future<HiveAesCipher> _initCipher(BiometricStorageFile store) async {
    String? key = await store.read();
    if (key == null) {
      key = base64.encode(Hive.generateSecureKey());
      await store.write(key);
    }

    return HiveAesCipher(base64Url.decode(key));
  }

  Future<void> _openBoxes(HiveAesCipher cipher) async {
    var iterator = boxesToOpen.iterator;

    var futures = <Future>[];
    while (iterator.moveNext()) {
      futures.add(Hive.openBox(iterator.current, encryptionCipher: cipher));
    }

    await Future.wait(futures);
  }
}
