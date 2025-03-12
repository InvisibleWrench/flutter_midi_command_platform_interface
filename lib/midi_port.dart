enum MidiPortType { IN, OUT }

class MidiPort {
  MidiPortType type;
  int id;
  bool connected = false;
  String name;

  MidiPort(this.id, this.type, this.name);

  Map<String, Object> get toDictionary {
    return {"id": id, "name": name, "type": type.toString(), "connected": connected};
  }
}
