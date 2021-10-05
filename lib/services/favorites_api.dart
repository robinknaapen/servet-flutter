import 'package:hive/hive.dart';
import 'package:servet/hive/hive_init.dart';
import 'package:servet/models/favorite_model.dart';

class FavoritesAPI {
  Future<List<FavoriteModel>> get() async {
    Box<FavoriteModel> box = await Hive.openBox('favorites',
        encryptionCipher: await HiveInstance().cipher());

    return box.values.toList();
  }

  Future<void> put(FavoriteModel f) async {
    Box<FavoriteModel> box = await Hive.openBox('favorites',
        encryptionCipher: await HiveInstance().cipher());

    return box.put(f.id, f);
  }

  Future<void> delete(int id) async {
    Box<FavoriteModel> box = await Hive.openBox('favorites',
        encryptionCipher: await HiveInstance().cipher());

    try {
      return box.delete(id);
    } catch (_) {
      return;
    }
  }
}
