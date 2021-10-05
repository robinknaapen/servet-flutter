import 'package:json_annotation/json_annotation.dart';
part 'token_response.g.dart';

@JsonSerializable()
class TokenResponse {
  final Uri url;
  final String token;

  TokenResponse({required this.url, required this.token});

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
}
