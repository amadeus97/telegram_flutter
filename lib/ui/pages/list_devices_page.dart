import 'package:flutter/material.dart';
import 'package:telegram_flutter/logic/bluetooth_manager.dart';
import 'package:telegram_flutter/logic/data/bluetooth_device_info.dart';
import 'package:telegram_flutter/main.dart';
import 'package:telegram_flutter/ui/common/distance_text.dart';
import 'package:telegram_flutter/ui/modals/ok_cancel_dialog.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class ListDevicesPage extends StatelessWidget with GetItMixin {
  ListDevicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var devices = watchX((BlueToothManager m) => m.visibleDevices);
    return ListView(
      children: devices.map(_DeviceListTile.new).toList(),
    );
  }
}

/// Renders info for a single bluetooth device.
/// Triggers the [bluetooth.addIgnoredDevice] action on tap
class _DeviceListTile extends StatelessWidget with GetItMixin {
  _DeviceListTile(this.device, {Key? key}) : super(key: key);
  final BtDeviceInfo device;

  @override
  Widget build(BuildContext context) {
    /// This method could be moved into something like `AppManager.confirmAndIgnoreDevice(device)` action,
    /// which would make sense if this logical flow is repeated in more than one view
    void handleDeviceTap() async {
      const dialog =
          OkCancelDialog(title: 'Ignore device', desc: 'Are you sure?');
      bool? ignore = await app.openDialog(context, dialog);
      if (ignore ?? false) {
        bluetooth.addIgnoredDevice(device);
      }
    }

    return ListTile(
        onTap: handleDeviceTap,
        contentPadding: const EdgeInsets.all(16),
        title: Text(device.name),
        trailing: DistanceText(distance: device.distance));
  }
}
