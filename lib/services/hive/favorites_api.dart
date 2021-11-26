import 'package:hive/hive.dart';
import 'package:servet/models/favorite_model.dart';

class FavoritesAPI {
  Box<Map<int, FavoriteModel>> box = Hive.box('favorites');

  Map<int, FavoriteModel> get(int hashCode) {
    return box.get(hashCode) ?? {};
  }

  Future<void> put(int hashCode, FavoriteModel f) async {
    var m = get(hashCode);
    m[f.id] = f;

    return box.put(hashCode, m);
  }

  Future<void> delete(int hashCode, int id) async {
    var m = get(hashCode);
    m.remove(id);

    await box.put(hashCode, m);
  }
}
