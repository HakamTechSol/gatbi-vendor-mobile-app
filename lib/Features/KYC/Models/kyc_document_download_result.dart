import 'dart:typed_data';

class KycDocumentDownloadResult {
  const KycDocumentDownloadResult({
    required this.bytes,
    required this.mimeType,
    required this.fileName,
  });

  final Uint8List bytes;
  final String mimeType;
  final String fileName;
}
