import 'package:flutter_midi_command_platform_interface/midi_port.dart';

class MidiDevice {
  String name;
  String id;
  String type;
  List<MidiPort> inputPorts = [];
  List<MidiPort> outputPorts = [];
  bool connected;

  MidiDevice(this.id, this.name, this.type, this.connected);

  Map<String, Object> get toDictionary {
    return {
      "name": name,
      "id": id,
      "type": type,
      "connected": connected,
      // "inputs": inputPorts?.map((m) => m.toDictionary)?.toList(),
      // "outputs": outputPorts?.map((m) => m.toDictionary)?.toList(),
    };
  }
}
