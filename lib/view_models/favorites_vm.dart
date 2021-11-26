import 'package:flutter/widgets.dart';
import 'package:servet/models/favorite_model.dart';
import 'package:servet/services/hive/favorites_api.dart';

class FavoritesVM with ChangeNotifier {
  List<FavoritesViewModel> favorites = List.empty();

  fetch(int hashCode) {
    favorites = FavoritesAPI()
        .get(hashCode)
        .values
        .map((e) => FavoritesViewModel(e))
        .toList();

    favorites.sort((a, b) => a.id.compareTo(b.id));
    notifyListeners();
  }

  Future<void> add(int hashCode, FavoriteModel f) async {
    await FavoritesAPI().put(hashCode, f);
    fetch(hashCode);
  }

  Future<void> delete(int hashCode, int id) async {
    await FavoritesAPI().delete(hashCode, id);
    fetch(hashCode);
  }
}

class FavoritesViewModel {
  final FavoriteModel _favorite;
  FavoritesViewModel(this._favorite);

  int get id {
    return _favorite.id;
  }
}
