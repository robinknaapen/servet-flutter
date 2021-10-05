import 'package:hive_flutter/hive_flutter.dart';
part 'favorite_model.g.dart';

@HiveType(typeId: 2)
class FavoriteModel extends HiveObject {
  @HiveField(0)
  int id;

  FavoriteModel({required this.id});
}
