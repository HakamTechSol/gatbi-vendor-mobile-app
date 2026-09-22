// lib/Features/KYC/Models/vendor_kyc_document_model.dart

class VendorKycDocumentModel {
  const VendorKycDocumentModel({
    this.id,
    this.documentType,
    this.status,
    this.rejectionReason,
    this.fileUrl,
    this.uploadedAt,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final String? documentType;
  final String? status;
  final String? rejectionReason;
  final String? fileUrl;
  final String? uploadedAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorKycDocumentModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorKycDocumentModel();
    }

    return VendorKycDocumentModel(
      id: _parseInt(json['id']),
      documentType: _parseString(json['document_type']),
      status: _parseString(json['status']),
      rejectionReason: _parseString(json['rejection_reason']),
      fileUrl: _parseString(json['file_url']),
      uploadedAt: _parseString(json['uploaded_at']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'document_type': documentType,
      'status': status,
      'rejection_reason': rejectionReason,
      'file_url': fileUrl,
      'uploaded_at': uploadedAt,
    };
  }

  // ============================================================
  // Document Endpoint
  // ============================================================

  /// Protected API endpoint used to fetch the actual document.
  ///
  /// Example:
  /// /api/mobile/vendor/kyc/document/11
  ///
  /// The Dio interceptor will attach the Bearer token.
  String? get documentEndpoint {
    final value = fileUrl?.trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }

  // ============================================================
  // Document Availability
  // ============================================================

  bool get hasDocument {
    return documentEndpoint != null;
  }

  bool get isPending {
    return status?.trim().toLowerCase() == 'pending';
  }

  bool get isApproved {
    final value = status?.trim().toLowerCase();

    return value == 'approved' || value == 'accepted' || value == 'verified';
  }

  bool get isRejected {
    final value = status?.trim().toLowerCase();

    return value == 'rejected' || value == 'declined' || value == 'denied';
  }

  // ============================================================
  // Resolved File Name
  // ============================================================

  /// Generates a safe file name when the API does not provide
  /// Content-Disposition filename.
  ///
  /// Example:
  /// trade_license_11
  String get resolvedFileName {
    final type = documentType
        ?.trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');

    final documentTypeName = type == null || type.isEmpty
        ? 'kyc_document'
        : type;

    final documentId = id ?? 0;

    return '${documentTypeName}_$documentId';
  }

  // ============================================================
  // MIME Type
  // ============================================================

  /// Tries to determine MIME type from the URL.
  ///
  /// The repository will perform actual byte-signature detection
  /// when the server does not return a useful Content-Type.
  String get resolvedMimeType {
    final path = fileUrl?.split('?').first.trim().toLowerCase() ?? '';

    if (path.endsWith('.jpg') || path.endsWith('.jpeg')) {
      return 'image/jpeg';
    }

    if (path.endsWith('.png')) {
      return 'image/png';
    }

    if (path.endsWith('.webp')) {
      return 'image/webp';
    }

    if (path.endsWith('.gif')) {
      return 'image/gif';
    }

    if (path.endsWith('.pdf')) {
      return 'application/pdf';
    }

    return 'application/octet-stream';
  }

  // ============================================================
  // Document Type Label
  // ============================================================

  String get documentTypeLabel {
    final value = documentType?.trim();

    if (value == null || value.isEmpty) {
      return 'KYC Document';
    }

    return value
        .replaceAll('_', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  // ============================================================
  // Status Label
  // ============================================================

  String get statusLabel {
    final value = status?.trim();

    if (value == null || value.isEmpty) {
      return 'Unknown';
    }

    return value
        .replaceAll('_', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  // ============================================================
  // Rejection Check
  // ============================================================

  bool get hasRejectionReason {
    final value = rejectionReason?.trim();

    return value != null && value.isNotEmpty;
  }

  // ============================================================
  // String Parser
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      final result = value.trim();

      return result.isEmpty ? null : result;
    }

    return value.toString();
  }

  // ============================================================
  // Integer Parser
  // ============================================================

  static int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value.trim());
    }

    return null;
  }

  // ============================================================
  // Debug
  // ============================================================

  @override
  String toString() {
    return 'VendorKycDocumentModel('
        'id: $id, '
        'documentType: $documentType, '
        'status: $status, '
        'rejectionReason: $rejectionReason, '
        'fileUrl: $fileUrl, '
        'uploadedAt: $uploadedAt'
        ')';
  }
}
