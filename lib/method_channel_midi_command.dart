import 'dart:async';
import 'package:flutter/services.dart';
import 'flutter_midi_command_platform_interface.dart';

const MethodChannel _methodChannel =
    MethodChannel('plugins.invisiblewrench.com/flutter_midi_command');
const EventChannel _rxChannel =
    EventChannel('plugins.invisiblewrench.com/flutter_midi_command/rx_channel');
const EventChannel _setupChannel = EventChannel(
    'plugins.invisiblewrench.com/flutter_midi_command/setup_channel');
const EventChannel _bluetoothStateChannel = EventChannel(
    'plugins.invisiblewrench.com/flutter_midi_command/bluetooth_central_state');

/// An implementation of [MidiCommandPlatform] that uses method channels.
class MethodChannelMidiCommand extends MidiCommandPlatform {
  Stream<MidiPacket>? _rxStream;
  Stream<String>? _setupStream;
  Stream<String>? _bluetoothStateStream;

  /// Returns a list of found MIDI devices.
  @override
  Future<List<MidiDevice>?> get devices async {
    var devs = await _methodChannel.invokeMethod('getDevices');
    return devs.map<MidiDevice>((m) {
      var map = m.cast<String, Object>();
      var dev = MidiDevice(map["id"].toString(), map["name"] ?? "-",
          map["type"], map["connected"] == "true");
      dev.inputPorts = _portsFromDevice(map["inputs"], MidiPortType.IN);
      dev.outputPorts = _portsFromDevice(map["outputs"], MidiPortType.OUT);
      return dev;
    }).toList();
  }

  List<MidiPort> _portsFromDevice(List<dynamic>? portList, MidiPortType type) {
    if (portList == null) return [];
    var ports = portList.map<MidiPort>((e) {
      var portMap = (e as Map).cast<String, Object>();
      return MidiPort(portMap["id"] as int, type, portMap['name'] as String);
    });
    return ports.toList(growable: false);
  }

  /// Starts bluetooth subsystem.
  ///
  /// Shows an alert requesting access rights for bluetooth.
  @override
  Future<void> startBluetoothCentral() async {
    try {
      await _methodChannel.invokeMethod('startBluetoothCentral');
    } on PlatformException catch (e) {
      throw e.message!;
    }
  }

  /// Stream firing events whenever a change in bluetooth central state happens
  @override
  Stream<String>? get onBluetoothStateChanged {
    _bluetoothStateStream ??=
        _bluetoothStateChannel.receiveBroadcastStream().cast<String>();
    return _bluetoothStateStream;
  }

  /// Returns the current state of the bluetooth subsystem
  @override
  Future<String> bluetoothState() async {
    try {
      return await _methodChannel.invokeMethod('bluetoothState');
    } on PlatformException catch (e) {
      throw e.message!;
    }
  }

  /// Starts scanning for BLE MIDI devices.
  ///
  /// Found devices will be included in the list returned by [devices].
  @override
  Future<void> startScanningForBluetoothDevices() async {
    try {
      await _methodChannel.invokeMethod('scanForDevices');
    } on PlatformException catch (e) {
      throw e.message!;
    }
  }

  /// Stops scanning for BLE MIDI devices.
  @override
  void stopScanningForBluetoothDevices() {
    _methodChannel.invokeMethod('stopScanForDevices');
  }

  /// Connects to the device.
  @override
  Future<void> connectToDevice(MidiDevice device, {List<MidiPort>? ports}) {
    return _methodChannel.invokeMethod(
        'connectToDevice', {"device": device.toDictionary, "ports": ports});
  }

  /// Disconnects from the device.
  @override
  void disconnectDevice(MidiDevice device) {
    _methodChannel.invokeMethod('disconnectDevice', device.toDictionary);
  }

  /// Disconnects from all devices.
  @override
  void teardown() {
    _methodChannel.invokeMethod('teardown');
  }

  /// Sends data to the currently connected device.
  ///
  /// Data is an UInt8List of individual MIDI command bytes.
  @override
  void sendData(Uint8List data, {int? timestamp, String? deviceId}) {
    // print("send $data through method channel");
    _methodChannel.invokeMethod('sendData',
        {"data": data, "timestamp": timestamp, "deviceId": deviceId});
  }

  /// Stream firing events whenever a midi package is received.
  ///
  /// The event contains the raw bytes contained in the MIDI package.
  @override
  Stream<MidiPacket>? get onMidiDataReceived {
    // print("get on midi data");
    _rxStream ??= _rxChannel.receiveBroadcastStream().map<MidiPacket>((d) {
      var dd = d["device"];
      // print("device data $dd");
      if (dd["name"] == null) {
          dd["name"] = dd['id'];
      }
      var device = MidiDevice(
          dd['id'], dd["name"], dd["type"], dd["connected"] == "true");
      return MidiPacket(Uint8List.fromList(List<int>.from(d["data"])),
          d["timestamp"] as int, device);
    });
    return _rxStream;
  }

  /// Stream firing events whenever a change in the MIDI setup occurs.
  ///
  /// For example, when a new BLE devices is discovered.
  @override
  Stream<String>? get onMidiSetupChanged {
    _setupStream ??= _setupChannel.receiveBroadcastStream().cast<String>();
    return _setupStream;
  }

  /// Creates a virtual MIDI source
  ///
  /// The virtual MIDI source appears as a virtual port in other apps.
  /// Currently only supported on iOS.
  @override
  void addVirtualDevice({String? name}) {
    _methodChannel.invokeMethod('addVirtualDevice', {"name": name});
  }

  /// Removes a previously addd virtual MIDI source.
  @override
  void removeVirtualDevice({String? name}) {
    _methodChannel.invokeMethod('removeVirtualDevice', {"name": name});
  }

  /// Returns the current state of the network session
  ///
  /// This is functional on iOS only, will return null on other platforms
  Future<bool?> get isNetworkSessionEnabled {
    return _methodChannel.invokeMethod('isNetworkSessionEnabled');
  }

  /// Sets the enabled state of the network session
  ///
  /// This is functional on iOS only
  void setNetworkSessionEnabled(bool enabled) {
    _methodChannel.invokeMethod('enableNetworkSession', enabled);
  }

  /// Returns the current state of the raw MIDI message receiving flag.
  Future<bool?> getRawMidiDataReceivingEnabled(String deviceId) {
    return _methodChannel.invokeMethod('isRawMidiDataReceivingEnabled', {'deviceId': deviceId});
  }

  /// Sets the enabled state of raw MIDI data recieving.
  Future<void> setRawMidiDataReceivingEnabled(String deviceId, bool enabled) {
    return _methodChannel.invokeMethod(
      'enableRawMidiDataReceiving',
      {'deviceId': deviceId, 'enabled': enabled},
    );
  }
}
