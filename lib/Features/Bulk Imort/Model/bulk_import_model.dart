enum BulkImportStatus {
  idle,
  selectingFile,
  ready,
  importing,
  completed,
  failed,
}

class BulkImportModel {
  const BulkImportModel({
    this.status = BulkImportStatus.idle,
    this.csvFileName,
    this.imagesZipFileName,
    this.jobId,
    this.totalRows = 0,
    this.processedRows = 0,
    this.successCount = 0,
    this.failedCount = 0,
    this.autoGenerateArabic = false,
    this.errorMessage,
  });

  /// Current import state.
  final BulkImportStatus status;

  /// Selected CSV/XLSX file name.
  final String? csvFileName;

  /// Optional images ZIP file name.
  final String? imagesZipFileName;

  /// Import job ID returned by backend.
  final String? jobId;

  /// Total number of products/rows.
  final int totalRows;

  /// Number of processed rows.
  final int processedRows;

  /// Successfully imported products.
  final int successCount;

  /// Failed products.
  final int failedCount;

  /// Whether Arabic draft generation is enabled.
  final bool autoGenerateArabic;

  /// Error returned by import process.
  final String? errorMessage;

  /// Import progress between 0.0 and 1.0.
  double get progress {
    if (totalRows <= 0) return 0;

    final value = processedRows / totalRows;

    return value.clamp(0.0, 1.0);
  }

  /// Progress percentage.
  int get progressPercentage => (progress * 100).round();

  /// Whether CSV file has been selected.
  bool get hasCsvFile =>
      csvFileName != null && csvFileName!.trim().isNotEmpty;

  /// Whether images ZIP has been selected.
  bool get hasImagesZip =>
      imagesZipFileName != null &&
      imagesZipFileName!.trim().isNotEmpty;

  /// Whether there is an import error.
  bool get hasError =>
      errorMessage != null && errorMessage!.trim().isNotEmpty;

  /// Whether import has finished.
  bool get isFinished => status == BulkImportStatus.completed;

  /// Whether import is currently running.
  bool get isImporting => status == BulkImportStatus.importing;

  BulkImportModel copyWith({
    BulkImportStatus? status,
    String? csvFileName,
    String? imagesZipFileName,
    String? jobId,
    int? totalRows,
    int? processedRows,
    int? successCount,
    int? failedCount,
    bool? autoGenerateArabic,
    String? errorMessage,
    bool clearCsvFile = false,
    bool clearImagesZipFile = false,
    bool clearJobId = false,
    bool clearError = false,
  }) {
    return BulkImportModel(
      status: status ?? this.status,

      csvFileName: clearCsvFile
          ? null
          : csvFileName ?? this.csvFileName,

      imagesZipFileName: clearImagesZipFile
          ? null
          : imagesZipFileName ?? this.imagesZipFileName,

      jobId: clearJobId ? null : jobId ?? this.jobId,

      totalRows: totalRows ?? this.totalRows,
      processedRows: processedRows ?? this.processedRows,
      successCount: successCount ?? this.successCount,
      failedCount: failedCount ?? this.failedCount,

      autoGenerateArabic:
          autoGenerateArabic ?? this.autoGenerateArabic,

      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  factory BulkImportModel.fromJson(Map<String, dynamic> json) {
    return BulkImportModel(
      status: _statusFromString(json['status']),
      csvFileName: json['csv_file_name'] as String?,
      imagesZipFileName: json['images_zip_file_name'] as String?,
      jobId: json['job_id'] as String?,
      totalRows: _toInt(json['total'] ?? json['total_rows']),
      processedRows: _toInt(
        json['processed'] ?? json['processed_rows'],
      ),
      successCount: _toInt(
        json['success'] ?? json['success_count'],
      ),
      failedCount: _toInt(
        json['failed'] ?? json['failed_count'],
      ),
      autoGenerateArabic:
          json['auto_generate_arabic'] == true,
      errorMessage: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'csv_file_name': csvFileName,
      'images_zip_file_name': imagesZipFileName,
      'job_id': jobId,
      'total': totalRows,
      'processed': processedRows,
      'success': successCount,
      'failed': failedCount,
      'auto_generate_arabic': autoGenerateArabic,
      'message': errorMessage,
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static BulkImportStatus _statusFromString(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'selecting_file':
        return BulkImportStatus.selectingFile;

      case 'ready':
        return BulkImportStatus.ready;

      case 'importing':
        return BulkImportStatus.importing;

      case 'completed':
      case 'complete':
        return BulkImportStatus.completed;

      case 'failed':
      case 'error':
        return BulkImportStatus.failed;

      default:
        return BulkImportStatus.idle;
    }
  }
}