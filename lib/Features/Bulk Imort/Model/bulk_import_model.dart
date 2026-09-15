enum BulkImportStatus { idle, ready, importing, completed, failed }

class BulkImportModel {
  const BulkImportModel({
    this.status = BulkImportStatus.idle,
    this.csvFileName,
    this.imagesZipFileName,
    this.autoGenerateArabic = false,
    this.processedRows = 0,
    this.totalRows = 0,
    this.successCount = 0,
    this.failedCount = 0,
    this.errorMessage,
  });

  final BulkImportStatus status;

  final String? csvFileName;

  final String? imagesZipFileName;

  final bool autoGenerateArabic;

  /// Current processed offset returned by API.
  final int processedRows;

  /// Total rows returned by API.
  final int totalRows;

  /// Products successfully created by API.
  final int successCount;

  /// Rows skipped / failed by API.
  final int failedCount;

  /// General UI/API error message.
  final String? errorMessage;

  // ===========================================================================
  // FILE STATE
  // ===========================================================================

  bool get hasCsvFile {
    final value = csvFileName?.trim();

    return value != null && value.isNotEmpty;
  }

  bool get hasImagesZipFile {
    final value = imagesZipFileName?.trim();

    return value != null && value.isNotEmpty;
  }

  // ===========================================================================
  // IMPORT STATE
  // ===========================================================================

  bool get isIdle => status == BulkImportStatus.idle;

  bool get isReady => status == BulkImportStatus.ready;

  bool get isImporting => status == BulkImportStatus.importing;

  bool get isCompleted => status == BulkImportStatus.completed;

  bool get isFailed => status == BulkImportStatus.failed;

  // ===========================================================================
  // PROGRESS
  // ===========================================================================

  double get progress {
    if (totalRows <= 0) {
      return 0;
    }

    final value = processedRows / totalRows;

    if (value < 0) {
      return 0;
    }

    if (value > 1) {
      return 1;
    }

    return value;
  }

  int get progressPercentage {
    return (progress * 100).round();
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================

  bool get hasError {
    final value = errorMessage?.trim();

    return value != null && value.isNotEmpty;
  }

  // ===========================================================================
  // COPY WITH
  // ===========================================================================

  BulkImportModel copyWith({
    BulkImportStatus? status,
    String? csvFileName,
    String? imagesZipFileName,
    bool? autoGenerateArabic,
    int? processedRows,
    int? totalRows,
    int? successCount,
    int? failedCount,
    String? errorMessage,
    bool clearCsvFile = false,
    bool clearImagesZipFile = false,
    bool clearErrorMessage = false,
  }) {
    return BulkImportModel(
      status: status ?? this.status,
      csvFileName: clearCsvFile ? null : csvFileName ?? this.csvFileName,
      imagesZipFileName: clearImagesZipFile
          ? null
          : imagesZipFileName ?? this.imagesZipFileName,
      autoGenerateArabic: autoGenerateArabic ?? this.autoGenerateArabic,
      processedRows: processedRows ?? this.processedRows,
      totalRows: totalRows ?? this.totalRows,
      successCount: successCount ?? this.successCount,
      failedCount: failedCount ?? this.failedCount,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  // ===========================================================================
  // API MAPPING
  // ===========================================================================

  /// Creates UI state from the process API response.
  ///
  /// API source:
  /// ImportProcessModel
  factory BulkImportModel.fromProcessResult(
    dynamic result, {
    required String? csvFileName,
    required String? imagesZipFileName,
    required bool autoGenerateArabic,
  }) {
    return BulkImportModel(
      status: BulkImportStatus.importing,
      csvFileName: csvFileName,
      imagesZipFileName: imagesZipFileName,
      autoGenerateArabic: autoGenerateArabic,
      processedRows: result.offset,
      totalRows: result.total,
      successCount: result.created,
      failedCount: result.skipped,
      errorMessage: result.hasErrors ? result.errors.join('\n') : null,
    );
  }

  /// Creates completed UI state from the process API response.
  factory BulkImportModel.fromCompletedProcess(
    dynamic result, {
    required String? csvFileName,
    required String? imagesZipFileName,
    required bool autoGenerateArabic,
  }) {
    return BulkImportModel(
      status: BulkImportStatus.completed,
      csvFileName: csvFileName,
      imagesZipFileName: imagesZipFileName,
      autoGenerateArabic: autoGenerateArabic,
      processedRows: result.offset,
      totalRows: result.total,
      successCount: result.created,
      failedCount: result.skipped,
      errorMessage: result.hasErrors ? result.errors.join('\n') : null,
    );
  }

  /// Creates failed UI state.
  factory BulkImportModel.failed({
    required String message,
    String? csvFileName,
    String? imagesZipFileName,
    bool autoGenerateArabic = false,
    int processedRows = 0,
    int totalRows = 0,
    int successCount = 0,
    int failedCount = 0,
  }) {
    return BulkImportModel(
      status: BulkImportStatus.failed,
      csvFileName: csvFileName,
      imagesZipFileName: imagesZipFileName,
      autoGenerateArabic: autoGenerateArabic,
      processedRows: processedRows,
      totalRows: totalRows,
      successCount: successCount,
      failedCount: failedCount,
      errorMessage: message,
    );
  }
}
