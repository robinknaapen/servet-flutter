import 'package:flutter/material.dart';
import 'package:servet/models/service_model.dart';
import 'package:servet/services/service_api.dart';

class ServiceListVM with ChangeNotifier {
  List<ServiceViewModel> services = List.empty();
  List<ServiceViewModel> _all = List.empty();

  Future<void> fetchServices(ServicesAPI api) async {
    final results = await api.getAll();

    _all = results.map((result) => ServiceViewModel(result)).toList();
    _all.sort((a, b) => a.name.compareTo(b.name));

    services = _all;

    notifyListeners();
  }

  filterByName(String name) {
    services = _all.where((service) => service.name.contains(name)).toList();
    services.sort((a, b) => a.name.compareTo(b.name));

    notifyListeners();
  }

  Future<void> refresh(ServicesAPI api) async {
    // tmp exists to preserve filtered results
    List<ServiceViewModel> tmp = services;

    await fetchServices(api);
    if (tmp.isEmpty) {
      return;
    }

    services = services
        .where((service) => tmp.indexWhere((t) => t.name == service.name) != -1)
        .toList();
    services.sort((a, b) => a.name.compareTo(b.name));
  }
}

class ServiceViewModel {
  final ServiceModel service;
  ServiceViewModel(this.service);

  int? get id {
    return service.id;
  }

  String get name {
    return service.name;
  }

  ServiceState get state {
    return service.state;
  }
}
