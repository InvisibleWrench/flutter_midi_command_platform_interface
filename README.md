# flutter_midi_command

The interface for
A Flutter plugin for sending and receiving MIDI messages between Flutter and physical and virtual MIDI devices. 

Wraps CoreMIDI and android.media.midi in a thin dart/flutter layer.
Works with USB and BLE MIDI connections on Android, and USB, network(session) and BLE MIDI connections on iOS.

## Getting Started

This plugin is build using Swift and Kotlin on the native side, so make sure your project supports this.

Import flutter_midi_command

`import 'package:flutter_midi_command/flutter_midi_command.dart';`

- Get a list of available MIDI devices by calling `MidiCommand().devices` which returns a list of `MidiDevice`
- Start bluetooth subsystem by calling `MidiCommand().startBluetoothCentral()`
- Observe the bluetooth system state by calling `MidiCommand().onBluetoothStateChanged()`
- Get the current bluetooth system state by calling `MidiCommand().bluetoothState()`
- Start scanning for BLE MIDI devices by calling `MidiCommand().startScanningForBluetoothDevices()`
- Connect to a specific `MidiDevice` by calling `MidiCommand.connectToDevice(selectedDevice)`
- Stop scanning for BLE MIDI devices by calling `MidiCommand().stopScanningForBluetoothDevices()`
- Disconnect from the current device by calling `MidiCommand.disconnectDevice()`
- Listen for updates in the MIDI setup by subscribing to `MidiCommand().onMidiSetupChanged`
- Listen for incoming MIDI messages on from the current device by subscribing to `MidiCommand().onMidiDataReceived`, after which the listener will recieve inbound MIDI messages as an UInt8List of variable length.
- Send a MIDI message by calling `MidiCommand.sendData(data)`, where data is an UInt8List of bytes following the MIDI spec.
- Or use the various `MidiCommand` subtypes to send PC, CC, NoteOn and NoteOff messsages.
- On iOS use `MidiCommand().addVirtualDevice(name: "Your Device Name")` to create a virtual MIDI destination and a virtual MIDI source. These virtual MIDI devices show up in other apps and can be used by other apps to send and receive MIDI to or from your app. To make this feature work, enable background audio for your app, i.e., add key `UIBackgroundModes` with value `audio` to your app's `info.plist` file.

See example folder for how to use.

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).
