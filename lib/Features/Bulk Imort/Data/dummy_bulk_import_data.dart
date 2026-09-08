

import '../Model/bulk_import_model.dart';

abstract final class DummyBulkImportData {
  DummyBulkImportData._();

  // ═══════════════════════════════════════════════════════════════════════════
  // DEFAULT STATE
  // ═══════════════════════════════════════════════════════════════════════════

  static const BulkImportModel initial = BulkImportModel(
    status: BulkImportStatus.idle,
    csvFileName: null,
    imagesZipFileName: null,
    jobId: null,
    totalRows: 0,
    processedRows: 0,
    successCount: 0,
    failedCount: 0,
    autoGenerateArabic: false,
    errorMessage: null,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // READY STATE
  // ═══════════════════════════════════════════════════════════════════════════

  static const BulkImportModel ready = BulkImportModel(
    status: BulkImportStatus.ready,
    csvFileName: 'products_import.csv',
    imagesZipFileName: 'product_images.zip',
    jobId: null,
    totalRows: 0,
    processedRows: 0,
    successCount: 0,
    failedCount: 0,
    autoGenerateArabic: true,
    errorMessage: null,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // IMPORTING STATE
  // ═══════════════════════════════════════════════════════════════════════════

  static const BulkImportModel importing = BulkImportModel(
    status: BulkImportStatus.importing,
    csvFileName: 'products_import.csv',
    imagesZipFileName: 'product_images.zip',
    jobId: 'bulk-import-demo-001',
    totalRows: 200,
    processedRows: 128,
    successCount: 124,
    failedCount: 4,
    autoGenerateArabic: true,
    errorMessage: null,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPLETED STATE
  // ═══════════════════════════════════════════════════════════════════════════

  static const BulkImportModel completed = BulkImportModel(
    status: BulkImportStatus.completed,
    csvFileName: 'products_import.csv',
    imagesZipFileName: 'product_images.zip',
    jobId: 'bulk-import-demo-001',
    totalRows: 200,
    processedRows: 200,
    successCount: 194,
    failedCount: 6,
    autoGenerateArabic: true,
    errorMessage: null,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // FAILED STATE
  // ═══════════════════════════════════════════════════════════════════════════

  static const BulkImportModel failed = BulkImportModel(
    status: BulkImportStatus.failed,
    csvFileName: 'products_import.csv',
    imagesZipFileName: 'product_images.zip',
    jobId: 'bulk-import-demo-001',
    totalRows: 200,
    processedRows: 76,
    successCount: 71,
    failedCount: 5,
    autoGenerateArabic: true,
    errorMessage:
        'Import could not be completed. Please review the failed rows.',
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // CSV COLUMNS
  // ═══════════════════════════════════════════════════════════════════════════

  static const List<String> requiredColumns = [
    'sku',
    'name',
    'price',
    'stock_qty',
    'category_id',
    'hero_image',
  ];

  static const List<String> optionalColumns = [
    'description',
    'brand',
    'gallery_images',
    'translate_ar',
    'name_ar',
    'description_ar',
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // SUPPORTED IMAGE FORMATS
  // ═══════════════════════════════════════════════════════════════════════════

  static const List<String> supportedImageFormats = ['JPG', 'PNG', 'WEBP'];

  // ═══════════════════════════════════════════════════════════════════════════
  // IMPORT INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════

  static const String csvHelperText = 'UTF-8 CSV • One row per product';

  static const String zipHelperText = 'Optional • JPG, PNG and WEBP images';

  static const String arabicDescription =
      'Automatically generate an Arabic draft for '
      'supported product fields.';

  static const String imageLinkDescription =
      'Use the image file name in your CSV columns '
      'to link images from the uploaded ZIP file.';

  static const String zipStructureDescription =
      'Keep image files inside the ZIP and use matching '
      'file names in the CSV.';

  // ═══════════════════════════════════════════════════════════════════════════
  // DUMMY FILE NAMES
  // ═══════════════════════════════════════════════════════════════════════════

  static const String sampleCsvFileName = 'products_import.csv';

  static const String sampleExcelFileName = 'products_template.xlsx';

  static const String sampleImagesZipFileName = 'product_images.zip';
}
