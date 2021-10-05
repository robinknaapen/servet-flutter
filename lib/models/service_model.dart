import 'package:json_annotation/json_annotation.dart';
part 'service_model.g.dart';

enum ServiceState {
  dead,
  exited,
  waiting,
  running,
  failed,
}

@JsonSerializable()
class ServiceModel {
  final int? id;
  final String name;
  final ServiceState state;

  @JsonKey(name: "object_path")
  final String objectPath;

  ServiceModel(
      {this.id,
      required this.name,
      required this.state,
      required this.objectPath});

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);
}
