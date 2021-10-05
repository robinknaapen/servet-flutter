import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:servet/hive/hive_init.dart';
import 'package:servet/router.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(const Servet());
}

class Servet extends StatelessWidget {
  const Servet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: HiveInstance().init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          return MaterialApp.router(
            title: 'Servet',
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
            ],
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routeInformationParser: const QRouteInformationParser(),
            routerDelegate: QRouterDelegate(
              AppRoutes().routes(),
            ),
          );
        });
  }
}
