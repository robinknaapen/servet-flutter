import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:servet/components/drawer.dart';
import 'package:servet/components/service_state_icon.dart';
import 'package:servet/models/favorite_model.dart';
import 'package:servet/models/service_model.dart';
import 'package:servet/services/http/service_api.dart';
import 'package:servet/view_models/favorites_vm.dart';
import 'package:servet/view_models/settings_vm.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  late Timer timer;

  @override
  void initState() {
    super.initState();

    Provider.of<SettingsVM>(context, listen: false).fetch();
    FavoritesVM favoritesVM = Provider.of<FavoritesVM>(context, listen: false);

    favoritesVM.fetch();
    timer = Timer.periodic(const Duration(seconds: 5),
        (Timer t) async => await favoritesVM.fetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      drawer: const DrawerComponent(),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        _list(),
      ],
    );
  }

  Widget _fallback() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
        spacing: 16,
        children: [
          const Icon(
            Icons.favorite,
            color: Colors.pink,
            size: 52,
          ),
          const Text(
            "No favorites yet",
            style: TextStyle(fontSize: 32, color: Colors.black26),
          ),
          TextButton(
            onPressed: () => {
              QR.navigator.replaceAllWithName('/services'),
            },
            child: const Text("Add some here"),
          )
        ],
      ),
    );
  }

  Widget _list() {
    return Expanded(
      child: Consumer2<FavoritesVM, SettingsVM>(
        builder: (context, favoritesVM, settingsVM, child) {
          if (favoritesVM.favorites == null || favoritesVM.favorites!.isEmpty) {
            return _fallback();
          }

          return RefreshIndicator(
            onRefresh: () async => await favoritesVM.fetch(),
            child: ListView.builder(
              itemCount: favoritesVM.favorites!.length,
              itemBuilder: (context, index) {
                ServicesAPI servicesAPI = ServicesAPI(
                  baseURL: settingsVM.settings!.host!,
                  token: settingsVM.settings!.token!,
                );

                return FutureBuilder<ServiceModel?>(
                  future: servicesAPI
                      .getByID(favoritesVM.favorites!.elementAt(index).id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Card(
                        child: ListTile(
                          leading: CircularProgressIndicator(),
                        ),
                      );
                    }

                    ServiceModel service = snapshot.data!;

                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${service.name} removed from favorites',
                                ),
                                duration: const Duration(seconds: 1),
                                action: SnackBarAction(
                                  label: "undo",
                                  onPressed: () {
                                    favoritesVM
                                        .add(FavoriteModel(id: service.id!));
                                  },
                                ),
                              ),
                            )
                            .closed
                            .then((reason) {
                          if (reason == SnackBarClosedReason.timeout) {
                            favoritesVM.delete(service.id!);
                          }
                        });

                        return Future.value(true);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(snapshot.data!.name),
                          subtitle: Text(snapshot.data!.objectPath),
                          trailing:
                              ServiceStateIcon(state: snapshot.data!.state),
                        ),
                      ),
                      background: Container(
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
