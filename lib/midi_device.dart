import 'package:flutter_midi_command_platform_interface/midi_port.dart';
import 'package:flutter_midi_command_platform_interface/guid.dart';

export 'guid.dart';

class MidiDevice {
  String name;
  String id;
  String type;
  List<MidiPort> inputPorts = [];
  List<MidiPort> outputPorts = [];
  bool connected;
  List<Guid> serviceUUIDs = [];

  MidiDevice(this.id, this.name, this.type, this.connected);

  Map<String, Object> get toDictionary {
    return {
      "name": name,
      "id": id,
      "type": type,
      "connected": connected,
    };
  }
}
