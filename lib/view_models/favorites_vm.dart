import 'package:flutter/widgets.dart';
import 'package:servet/models/favorite_model.dart';
import 'package:servet/services/favorites_api.dart';

class FavoritesVM with ChangeNotifier {
  List<FavoritesViewModel>? favorites;

  Future<void> fetch() async {
    favorites =
        (await FavoritesAPI().get()).map((e) => FavoritesViewModel(e)).toList();
    favorites?.sort((a, b) => a.id.compareTo(b.id));

    notifyListeners();
  }

  Future<void> add(FavoriteModel f) async {
    await FavoritesAPI().put(f);
    return fetch();
  }

  Future<void> delete(int id) async {
    await FavoritesAPI().delete(id);
    return fetch();
  }
}

class FavoritesViewModel {
  final FavoriteModel _favorite;
  FavoritesViewModel(this._favorite);

  int get id {
    return _favorite.id;
  }
}
