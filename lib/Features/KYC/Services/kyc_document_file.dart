class KycDocumentFile {
  const KycDocumentFile({
    required this.path,
    required this.name,
    required this.sizeBytes,
    required this.isImage,
  });

  final String path;
  final String name;
  final int sizeBytes;
  final bool isImage;

  double get sizeInMb => sizeBytes / (1024 * 1024);

  String get formattedSize {
    if (sizeBytes < 1024) {
      return '$sizeBytes B';
    }

    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }

    return '${sizeInMb.toStringAsFixed(1)} MB';
  }
}