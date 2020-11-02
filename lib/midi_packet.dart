import 'dart:typed_data';

class MidiPacket {
  int timestamp;
  Uint8List data;

  MidiPacket(this.data, this.timestamp);

  Map<String, Object> get toDictionary {
    return {"data": data, "timestamp": timestamp};
  }
}
