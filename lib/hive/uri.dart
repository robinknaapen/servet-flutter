import 'package:hive/hive.dart';

class UriAdapter extends TypeAdapter<Uri> {
  @override
  final typeId = 1;

  @override
  Uri read(BinaryReader reader) {
    try {
      String s = reader.readString();
      return Uri.parse(s);
    } catch (_) {
      return Uri();
    }
  }

  @override
  void write(BinaryWriter writer, Uri obj) {
    writer.writeString(obj.toString());
  }
}
