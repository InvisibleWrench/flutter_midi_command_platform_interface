import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_midi_command_platform_interface/midi_device.dart';
import 'package:flutter_midi_command_platform_interface/midi_packet.dart';
import 'package:flutter_midi_command_platform_interface/midi_port.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'method_channel_midi_command.dart';

export 'package:flutter_midi_command_platform_interface/midi_device.dart';
export 'package:flutter_midi_command_platform_interface/midi_packet.dart';
export 'package:flutter_midi_command_platform_interface/midi_port.dart';

abstract class MidiCommandPlatform extends PlatformInterface {
  /// Constructs a MidiCommandPlatform.
  MidiCommandPlatform() : super(token: _token);

  static final Object _token = Object();

  static MidiCommandPlatform _instance = MethodChannelMidiCommand();

  /// The default instance of [MidiCommandPlatform] to use.
  ///
  /// Defaults to [MethodChannelMidiCommand].
  static MidiCommandPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [MidiCommandPlatform] when they register themselves.
  static set instance(MidiCommandPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns a list of found MIDI devices.
  Future<List<MidiDevice>?> get devices async {
    throw UnimplementedError('get devices has not been implemented.');
  }

  /// Starts bluetooth subsystem. Shows an alert requesting access rights for
  /// bluetooth.
  Future<void> startBluetoothCentral() async {
    throw UnimplementedError(
        'startBluetoothCentral() has not been implemented.');
  }

  /// Stream firing events whenever the bluetooth central state changes
  Stream<String>? get onBluetoothStateChanged {
    throw UnimplementedError(
        'get onBluetoothStateChanged has not been implemented.');
  }

  /// Returns the current state of the bluetooth sub system
  Future<String> bluetoothState() async {
    throw UnimplementedError('bluetoothState() has not been implemented.');
  }

  /// Starts scanning for BLE MIDI devices.
  ///
  /// Found devices will be included in the list returned by [devices].
  Future<void> startScanningForBluetoothDevices() async {
    throw UnimplementedError(
        'startScanningForBluetoothDevices() has not been implemented.');
  }

  /// Stops scanning for BLE MIDI devices.
  void stopScanningForBluetoothDevices() {
    throw UnimplementedError(
        'stopScanningForBluetoothDevices() has not been implemented.');
  }

  /// Connects to the device.
  Future<void> connectToDevice(MidiDevice device, {List<MidiPort>? ports}) {
    throw UnimplementedError('connectToDevice() has not been implemented.');
  }

  /// Disconnects from the device.
  void disconnectDevice(MidiDevice device) {
    throw UnimplementedError('disconnectDevice() has not been implemented.');
  }

  /// Disconnects from all devices.
  void teardown() {
    throw UnimplementedError('teardown() has not been implemented.');
  }

  /// Sends data to the currently connected device.
  ///
  /// Data is an UInt8List of individual MIDI command bytes.
  void sendData(Uint8List data, {int? timestamp, String? deviceId}) {
    throw UnimplementedError('sendData() has not been implemented.');
  }

  Stream<MidiPacket>? get onMidiDataReceived {
    throw UnimplementedError(
        'get onMidiDataReceived has not been implemented.');
  }

  /// Stream firing events whenever a change in the MIDI setup occurs.
  ///
  /// For example, when a new BLE devices is discovered.
  Stream<String>? get onMidiSetupChanged {
    throw UnimplementedError(
        'get onMidiSetupChanged has not been implemented.');
  }

  /// Creates a virtual MIDI source.
  void addVirtualDevice({String? name}) {
    throw UnimplementedError('addVirtualDevice() has not been implemented.');
  }

  /// Removes a previously created virtual MIDI source.
  void removeVirtualDevice({String? name}) {
    throw UnimplementedError('removeVirtualDevice() has not been implemented.');
  }

  /// Returns the current state of the network session (iOS only)
  Future<bool?> get isNetworkSessionEnabled {
    throw UnimplementedError(
        'isNetworkSessionEnabled has not been implemented.');
  }

  /// Sets the enabled state of the network session (iOS only)
  void setNetworkSessionEnabled(bool enabled) {
    throw UnimplementedError(
        'setNetworkSessionEnabled has not been implemented.');

  /// Returns the current state of the raw MIDI receiving flag.
  Future<bool?> getRawMidiDataReceivingEnabled(String deviceId) {
    throw UnimplementedError('getRawMidiDataReceivingEnabled has not been implemented.');
  }

  /// When enabled all incoming MIDI packets are transmitted exactly as received,
  /// without compiling them into well formed MIDI messages.
  Future<void> setRawMidiDataReceivingEnabled(String deviceId, bool enabled) {
    throw UnimplementedError('setRawMidiDataReceivingEnabled has not been implemented.');
  }
}
