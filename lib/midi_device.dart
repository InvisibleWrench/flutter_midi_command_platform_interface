class MidiDevice {
  String name;
  String id;
  String type;
  bool connected;

  MidiDevice(this.id, this.name, this.type, this.connected);

  Map<String, Object> get toDictionary {
    return {"name": name, "id": id, "type": type};
  }
}
