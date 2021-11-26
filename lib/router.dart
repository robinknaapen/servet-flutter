import 'package:provider/provider.dart';
import 'package:qlevar_router/qlevar_router.dart';
// import 'package:servet/view_models/favorites_vm.dart';
// import 'package:servet/view_models/services_vm.dart';
import 'package:servet/view_models/settings_vm.dart';
// import 'package:servet/views/favorites_view.dart';
// import 'package:servet/views/services_view.dart';
import 'package:servet/views/settings_view.dart';

class SettingsMiddleware extends QMiddleware {
  final SettingsVM settingsVM;
  SettingsMiddleware({required this.settingsVM});

  @override
  Future<String?> redirectGuard(String path) async {
    settingsVM.fetch();
    if (settingsVM.settings.isEmpty) {
      return 'settings';
    }

    return null;
  }
}

class AppRoutes {
  List<QRoute> routes() {
    SettingsVM settingsVM = SettingsVM();
    // FavoritesVM favoritesVM = FavoritesVM();
    // ServiceListVM serviceListVM = ServiceListVM();

    return [
      // QRoute(
      //   path: '/',
      //   builder: () {
      //     return MultiProvider(
      //       providers: [
      //         ChangeNotifierProvider.value(value: favoritesVM),
      //         ChangeNotifierProvider.value(value: settingsVM),
      //       ],
      //       child: const FavoritesView(),
      //     );
      //   },
      //   middleware: [
      //     SettingsMiddleware(settingsVM: settingsVM),
      //   ],
      // ),
      // QRoute(
      //   path: '/services',
      //   builder: () {
      //     return MultiProvider(
      //       providers: [
      //         ChangeNotifierProvider.value(value: favoritesVM),
      //         ChangeNotifierProvider.value(value: serviceListVM),
      //         ChangeNotifierProvider.value(value: settingsVM),
      //       ],
      //       child: const ServicesView(),
      //     );
      //   },
      //   middleware: [
      //     SettingsMiddleware(settingsVM: settingsVM),
      //   ],
      // ),
      QRoute(
        path: '/settings',
        builder: () {
          return ChangeNotifierProvider.value(
            value: settingsVM,
            child: const SettingsView(),
          );
        },
      ),
    ];
  }
}
