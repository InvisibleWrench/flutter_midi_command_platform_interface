import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_midi_command_platform_interface/midi_device.dart';
import 'flutter_midi_command_platform_interface.dart';

const MethodChannel _methodChannel = MethodChannel('plugins.invisiblewrench.com/flutter_midi_command');
const EventChannel _rxChannel = EventChannel('plugins.invisiblewrench.com/flutter_midi_command/rx_channel');
const EventChannel _setupChannel = EventChannel('plugins.invisiblewrench.com/flutter_midi_command/setup_channel');

/// An implementation of [MidiCommandPlatform] that uses method channels.
class MethodChannelMidiCommand extends MidiCommandPlatform {
  Stream<Uint8List>? _rxStream;
  Stream<String>? _setupStream;

  /// Returns a list of found MIDI devices.
  @override
  Future<List<MidiDevice>?> get devices async {
    var devs = await _methodChannel.invokeMethod('getDevices');
    return devs.map<MidiDevice>((m) {
      var map = m.cast<String, Object>();
      return MidiDevice(map["id"], map["name"], map["type"], map["connected"] == "true");
    }).toList();
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
  void connectToDevice(MidiDevice device) {
    _methodChannel.invokeMethod('connectToDevice', device.toDictionary);
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
  void sendData(Uint8List data) {
    // print("send $data through method channel");
    _methodChannel.invokeMethod('sendData', data);
  }

  /// Stream firing events whenever a midi package is received.
  ///
  /// The event contains the raw bytes contained in the MIDI package.
  @override
  Stream<Uint8List>? get onMidiDataReceived {
    // print("get on midi data");
    _rxStream ??= _rxChannel.receiveBroadcastStream().map<Uint8List>((d) {
      return Uint8List.fromList(List<int>.from(d));
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
}
