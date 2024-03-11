import 'dart:typed_data';

class DroppedFile {
  final String url;
  final String name;
  final String mimeType;
  final Uint8List fileData;

  const DroppedFile({
    required this.url,
    required this.name,
    required this.mimeType,
    required this.fileData,
  });
}
