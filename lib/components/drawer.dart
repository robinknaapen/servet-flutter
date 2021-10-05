import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerComponent extends StatelessWidget {
  const DrawerComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: SvgPicture.asset('assets/images/napkin.svg'),
          ),
          ListTile(
            title: const Text("Favorites"),
            leading: const Icon(Icons.favorite),
            onTap: () => QR.navigator.replaceLastName('/'),
          ),
          ListTile(
            title: const Text("Services"),
            leading: const Icon(Icons.list),
            onTap: () => QR.navigator.replaceLastName('/services'),
          ),
          ListTile(
            title: const Text("Settings"),
            leading: const Icon(Icons.settings),
            onTap: () => QR.navigator.replaceLastName('/settings'),
          )
        ],
      ),
    );
  }
}
