import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servet/components/drawer.dart';
import 'package:servet/components/qrcode.dart';
import 'package:servet/view_models/settings_vm.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();

    Provider.of<SettingsVM>(context, listen: false).fetch();
  }

  @override
  Widget build(BuildContext context) {
    SettingsVM settingsVM = Provider.of<SettingsVM>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return QRCodeComponent(settingsVM: settingsVM);
                },
              );
            },
            icon: const Icon(Icons.qr_code),
          ),
        ],
      ),
      drawer: const DrawerComponent(),
      body: _buildUI(settingsVM),
    );
  }

  Widget _buildUI(SettingsVM settingsVM) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.topLeft,
      child: _list(),
    );
  }

  Widget _list() {
    return Consumer<SettingsVM>(
      builder: (context, settingsVM, child) {
        return ListView.builder(
          itemCount: settingsVM.settings.length,
          itemBuilder: (context, index) {
            var settings = settingsVM.settings[index];

            return Card(
              child: ListTile(
                title: Text(settings.host.toString()),
              ),
            );
          },
        );
      },
    );
  }
}
