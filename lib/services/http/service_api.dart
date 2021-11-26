import 'dart:convert';
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;
import 'package:servet/models/service_model.dart';

class ServicesAPI {
  Uri baseURL;
  String token;

  ServicesAPI({required this.baseURL, required this.token});

  Future<List<ServiceModel>> getAll() async {
    Uri url = baseURL.replace(path: '/services');

    try {
      http.Response response = await http.get(
        url,
        headers: Map.from({
          'Authorization': 'Bearer $token',
        }),
      );
      List json = jsonDecode(response.body) as List;

      return json.map((e) => ServiceModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint(e.toString());
    }

    return List.empty(growable: true);
  }

  Future<ServiceModel?> getByID(int id) async {
    Uri url = baseURL.replace(path: '/services/' + id.toString());

    try {
      http.Response response = await http.get(
        url,
        headers: Map.from({
          'Authorization': 'Bearer $token',
        }),
      );
      Map<String, dynamic> json = jsonDecode(response.body);

      return ServiceModel.fromJson(json);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
