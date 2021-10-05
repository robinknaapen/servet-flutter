import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:servet/models/service_model.dart';

class ServiceStateIcon extends StatelessWidget {
  final ServiceState state;
  const ServiceStateIcon({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case (ServiceState.running):
        return const Icon(Icons.bolt, color: Colors.green);
      case (ServiceState.exited):
        return const Icon(Icons.bolt, color: Colors.red);
      case (ServiceState.dead):
        return const Icon(Icons.bolt, color: Colors.black54);
      case (ServiceState.waiting):
        return const Icon(Icons.hourglass_empty, color: Colors.orange);
      case (ServiceState.failed):
        return const Icon(Icons.warning, color: Colors.red);
    }

    return const Icon(Icons.bolt, color: Colors.black54);
  }
}
