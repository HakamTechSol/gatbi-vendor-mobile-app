// lib/Features/KYC/Models/kyc_document_download_result.dart

import 'dart:typed_data';

class KycDocumentDownloadResult {
  const KycDocumentDownloadResult({
    required this.bytes,
    required this.mimeType,
    required this.fileName,
  });

  // ============================================================
  // Main Fields
  // ============================================================

  /// Actual downloaded document bytes.
  final Uint8List bytes;

  /// Resolved MIME type.
  ///
  /// Examples:
  /// image/jpeg
  /// image/png
  /// application/pdf
  final String mimeType;

  /// Final file name that will be used when saving the document.
  final String fileName;

  // ============================================================
  // File Information
  // ============================================================

  /// Returns true when the downloaded document is an image.
  bool get isImage {
    return mimeType.trim().toLowerCase().startsWith('image/');
  }

  /// Returns true when the downloaded document is a PDF.
  bool get isPdf {
    return mimeType.trim().toLowerCase() == 'application/pdf';
  }

  /// Returns true when the downloaded document has data.
  bool get hasBytes {
    return bytes.isNotEmpty;
  }

  /// Size of downloaded document in bytes.
  int get byteLength {
    return bytes.length;
  }

  /// Size of downloaded document in KB.
  double get sizeInKb {
    return bytes.length / 1024;
  }

  /// Size of downloaded document in MB.
  double get sizeInMb {
    return bytes.length / (1024 * 1024);
  }

  // ============================================================
  // File Extension
  // ============================================================

  String get extension {
    switch (mimeType.trim().toLowerCase()) {
      case 'image/jpeg':
      case 'image/jpg':
        return '.jpg';

      case 'image/png':
        return '.png';

      case 'image/webp':
        return '.webp';

      case 'image/gif':
        return '.gif';

      case 'application/pdf':
        return '.pdf';

      case 'text/plain':
        return '.txt';

      case 'application/json':
        return '.json';

      default:
        return '.bin';
    }
  }

  // ============================================================
  // Display Helpers
  // ============================================================

  String get fileTypeLabel {
    if (isPdf) {
      return 'PDF';
    }

    if (isImage) {
      return 'Image';
    }

    return 'Document';
  }

  String get formattedSize {
    if (bytes.isEmpty) {
      return '0 KB';
    }

    if (bytes.length < 1024 * 1024) {
      return '${sizeInKb.toStringAsFixed(1)} KB';
    }

    return '${sizeInMb.toStringAsFixed(2)} MB';
  }

  // ============================================================
  // Debug / JSON-like Information
  // ============================================================

  @override
  String toString() {
    return 'KycDocumentDownloadResult('
        'fileName: $fileName, '
        'mimeType: $mimeType, '
        'bytes: ${bytes.length}, '
        'isImage: $isImage, '
        'isPdf: $isPdf'
        ')';
  }
}