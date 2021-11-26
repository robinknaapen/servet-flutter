import 'dart:convert';
import 'dart:io';
import 'package:flutter/rendering.dart';
import "package:http/http.dart" as http;

import 'package:servet/models/token_response.dart';

class TokenAPIException implements Exception {
  final String message;
  final int statusCode;

  TokenAPIException({required this.message, required this.statusCode});
}

class TokenAPI {
  Uri baseURL;
  String token;
  TokenAPI({required this.baseURL, required this.token});

  Future<TokenResponse> issue() async {
    Uri url = baseURL.replace(path: '/issue');

    http.Response response = await http.get(
      url,
      headers: Map.from({
        'Authorization': 'Bearer $token',
      }),
    );

    if (response.statusCode != 200) {
      throw TokenAPIException(
        message: 'Unexpected status code',
        statusCode: response.statusCode,
      );
    }

    return TokenResponse.fromJson(jsonDecode(response.body));
  }
}
