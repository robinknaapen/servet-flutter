import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:servet/models/settings_model.dart';
import 'package:servet/models/token_response.dart';
import 'package:servet/services/http/token_api.dart';
import 'package:servet/view_models/settings_vm.dart';

class QRCodeComponent extends StatefulWidget {
  final SettingsVM settingsVM;
  const QRCodeComponent({Key? key, required this.settingsVM}) : super(key: key);

  @override
  State<QRCodeComponent> createState() => _QRCodeComponentState();
}

class _QRCodeComponentState extends State<QRCodeComponent> {
  final GlobalKey key = GlobalKey();
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan qrcode'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: key,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      this.controller?.pauseCamera();

      try {
        TokenResponse issueToken =
            TokenResponse.fromJson(jsonDecode(scanData.code));

        TokenAPI tokenAPI =
            TokenAPI(baseURL: issueToken.url, token: issueToken.token);
        TokenResponse apiToken = await tokenAPI.issue();

        await widget.settingsVM
            .put(SettingsModel(host: apiToken.url, token: apiToken.token));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully saved setting for ${apiToken.url}',
            ),
          ),
        );
      } on TokenAPIException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${e.message} ${e.statusCode}'),
          ),
        );
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unknown error occurred'),
          ),
        );
      }

      Navigator.of(context).pop(true);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
