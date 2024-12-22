import 'package:flutter_blue/flutter_blue.dart';

class BluetoothService {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? _connectedDevice;

  get characteristics => null;

  // Start scanning for Bluetooth devices
  Future<void> startBluetoothMeasurement() async {
    try {
      await flutterBlue.startScan(timeout: Duration(seconds: 5));

      flutterBlue.scanResults.listen((results) async {
        for (ScanResult r in results) {
          if (r.device.name == 'Your Device Name') {
            // Replace with your device's name
            await flutterBlue.stopScan();
            _connectedDevice = r.device;
            await _connectedDevice?.connect();
            await _discoverServices(_connectedDevice!);
            break;
          }
        }
      });
    } catch (e) {
      print('Error starting Bluetooth measurement: $e');
    }
  }

  Future<void> _discoverServices(BluetoothDevice device) async {
    try {
      List<BluetoothService> services =
          (await device.discoverServices()).cast<BluetoothService>();
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() ==
              '00002a37-0000-1000-8000-00805f9b34fb') {
            // Heart Rate Measurement
            await characteristic.setNotifyValue(true);
            characteristic.value.listen((value) {
              // Your heart rate parsing logic here...
            });
          }
        }
      }
    } catch (e) {
      print('Error discovering services: $e');
    }
  }

  // Disconnect the device
  Future<void> disconnectDevice() async {
    if (_connectedDevice != null) {
      await _connectedDevice?.disconnect();
      _connectedDevice = null;
    }
  }
}
