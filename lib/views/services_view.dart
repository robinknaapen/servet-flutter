import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:servet/components/drawer.dart';
import 'package:servet/components/service_state_icon.dart';
import 'package:servet/models/favorite_model.dart';
import 'package:servet/services/http/service_api.dart';
import 'package:servet/view_models/favorites_vm.dart';
import 'package:servet/view_models/services_vm.dart';
import 'package:servet/view_models/settings_vm.dart';

class ServicesView extends StatefulWidget {
  const ServicesView({Key? key}) : super(key: key);

  @override
  _ServicesViewState createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      drawer: const DrawerComponent(),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        _filter(),
        _servicesList(),
      ],
    );
  }

  Widget _filter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<ServiceListVM>(
        builder: (context, serviceListVM, child) {
          return TextField(
            autofillHints:
                serviceListVM.services.map<String>((service) => service.name),
            onChanged: (value) => serviceListVM.filterByName(value),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Filter services",
            ),
          );
        },
      ),
    );
  }

  Widget _servicesList() {
    return FutureBuilder(
      future: () async {
        SettingsVM settingsVM = Provider.of<SettingsVM>(context, listen: false);
        await settingsVM.get();

        ServicesAPI api = ServicesAPI(
          baseURL: settingsVM.settings!.host!,
          token: settingsVM.settings!.token!,
        );
        Provider.of<ServiceListVM>(context, listen: false).fetchServices(api);

        return api;
      }(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        ServicesAPI api = snapshot.data as ServicesAPI;

        return Expanded(
          child: Consumer3<ServiceListVM, SettingsVM, FavoritesVM>(
            builder: (_, serviceListVM, settingsVM, favoritesVM, child) {
              return RefreshIndicator(
                child: ListView.builder(
                  itemCount: serviceListVM.services.length,
                  itemBuilder: (context, index) {
                    ServiceViewModel service = serviceListVM.services[index];

                    return ListTile(
                      leading: _favoriteButton(service, favoritesVM),
                      trailing: Tooltip(
                        triggerMode: TooltipTriggerMode.tap,
                        message: service.state.toString(),
                        child: ServiceStateIcon(state: service.state),
                      ),
                      title: Text(service.name),
                    );
                  },
                ),
                onRefresh: () => serviceListVM.refresh(api),
              );
            },
          ),
        );
      },
    );
  }

  Widget _favoriteButton(ServiceViewModel service, FavoritesVM favoritesVM) {
    try {
      FavoritesViewModel? f =
          favoritesVM.favorites?.firstWhere((f) => f.id == service.id);

      if (f != null) {
        return IconButton(
          onPressed: () async {
            await favoritesVM.delete(f.id);
          },
          icon: const Icon(Icons.favorite),
          color: Colors.pink,
        );
      }
    } catch (_) {}

    return IconButton(
      onPressed: () async {
        await favoritesVM.add(FavoriteModel(id: service.id!));
      },
      icon: const Icon(Icons.favorite),
    );
  }
}
