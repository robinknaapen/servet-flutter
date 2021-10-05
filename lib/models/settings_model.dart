import 'package:hive_flutter/hive_flutter.dart';
part 'settings_model.g.dart';

@HiveType(typeId: 0)
class SettingsModel extends HiveObject {
  @HiveField(0)
  Uri? host;

  @HiveField(1)
  String? token;

  SettingsModel({
    this.host,
    this.token,
  });
}
