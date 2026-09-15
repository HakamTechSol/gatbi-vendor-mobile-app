import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Services/api_exception.dart';
import '../../../Services/file_download_service.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

import '../Import Process/Controller/import_process_controller.dart';
import '../Import Process/Models/import_process_model.dart';
import '../Import_Start/Controller/import_start_controller.dart';
import '../Model/bulk_import_model.dart';
import '../Reuse Widgets/bulk_import_action_buttons.dart';
import '../Reuse Widgets/bulk_import_file_picker.dart';
import '../Reuse Widgets/bulk_import_header.dart';
import '../Reuse Widgets/bulk_import_image_help.dart';
import '../Reuse Widgets/bulk_import_info_card.dart';
import '../Reuse Widgets/bulk_import_progress_card.dart';
import '../Reuse Widgets/bulk_import_required_columns.dart';
import '../Reuse Widgets/bulk_import_reset_dialog.dart';
import '../Reuse Widgets/bulk_import_toggle.dart';
import '../Sample CSV/Controller/sample_csv_controller.dart';
import '../Sample XLSX/Controller/sample_xlsx_controller.dart';

class BulkImportScreen extends ConsumerStatefulWidget {
  const BulkImportScreen({super.key});

  @override
  ConsumerState<BulkImportScreen> createState() => _BulkImportScreenState();
}

class _BulkImportScreenState extends ConsumerState<BulkImportScreen> {
  // ===========================================================================
  // STATE
  // ===========================================================================

  BulkImportModel _importData = const BulkImportModel();

  ImportProcessModel? _lastProcessResult;

  /// Actual selected CSV file.
  PlatformFile? _selectedCsvFile;

  // ignore: unused_field
  PlatformFile? _selectedImagesZipFile;

  /// Safety limit so process API can never create an endless loop.
  static const int _maxProcessAttempts = 100;

  /// Delay between process API calls.
  static const Duration _processDelay = Duration(milliseconds: 250);

  // ===========================================================================
  // CONTROLLERS
  // ===========================================================================

  SampleCsvController get _controller => ref.read(sampleCsvControllerProvider);

  SampleXlsxController get _xlsxController =>
      ref.read(sampleXlsxControllerProvider);

  ImportStartController get _importStartController =>
      ref.read(importStartControllerProvider);

  ImportProcessController get _importProcessController =>
      ref.read(importProcessControllerProvider);

  // ===========================================================================
  // STATIC UI CONFIGURATION
  // ===========================================================================

  static const String _csvHelperText =
      'Select a UTF-8 CSV file using the Gatbi import format.';

  static const String _zipHelperText =
      'Optional ZIP containing product images referenced by file name.';

  static const String _arabicDescription =
      'Automatically request Arabic draft content during import.';

  static const List<String> _requiredColumns = [
    'name',
    'description',
    'price',
    'category',
    'stock',
  ];

  static const List<String> _optionalColumns = [
    'sku',
    'brand',
    'barcode',
    'weight',
    'images',
  ];

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: BulkImportHeader(
        onBack: () {
          if (_importData.isImporting) {
            _showSnackBar('Please wait until the import is completed.');
            return;
          }

          Navigator.of(context).maybePop();
        },
        onHelp: _showHelpDialog,
      ),
    );
  }

  // ===========================================================================
  // CONTENT
  // ===========================================================================

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIntroCard(),

          const SizedBox(height: 20),

          _buildResourcesSection(),

          const SizedBox(height: 22),

          _buildSectionTitle(
            title: 'Upload Files',
            description:
                'Add your product CSV and optional product images ZIP.',
          ),

          const SizedBox(height: 12),

          _buildCsvPicker(),

          const SizedBox(height: 14),

          _buildImagesPicker(),

          const SizedBox(height: 18),

          BulkImportToggle(
            value: _importData.autoGenerateArabic,
            onChanged: _onArabicChanged,
            title: 'Auto-generate Arabic draft',
            description: _arabicDescription,
          ),

          const SizedBox(height: 20),

          _buildImportActionSection(),

          BulkImportProgressCard(
            importData: _importData,
            onViewErrors: _onViewErrors,
            onDone: _onImportDone,
          ),

          const SizedBox(height: 22),

          const BulkImportRequiredColumns(
            columns: _requiredColumns,
            title: 'Required CSV Columns',
            description: 'Make sure your CSV contains all required columns.',
          ),

          const SizedBox(height: 14),

          _buildOptionalColumns(),

          const SizedBox(height: 14),

          const BulkImportImageHelp(),

        ],
      ),
    );
  }

  // ===========================================================================
  // INTRO
  // ===========================================================================

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Import products in bulk',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Upload one CSV file to create or update '
                  'multiple products at once.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white.withValues(alpha: 0.86),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // RESOURCES
  // ===========================================================================

  Widget _buildResourcesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.download_outlined,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Import Resources',
                  style: AppTextStyles.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Download a template or sample files before preparing '
            'your import.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ResourceButton(
                icon: Icons.table_view_outlined,
                label: 'CSV Template',
                onTap: _onDownloadCsvTemplate,
              ),
              _ResourceButton(
                icon: Icons.description_outlined,
                label: 'Excel Template',
                onTap: _onDownloadExcelTemplate,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // FILE PICKERS
  // ===========================================================================

  Widget _buildCsvPicker() {
    return BulkImportFilePicker(
      title: 'Product CSV',
      required: true,
      selectedFileName: _importData.csvFileName,
      helperText: _csvHelperText,
      icon: Icons.table_chart_outlined,
      allowedFormats: const ['CSV'],
      onFileSelected: _onCsvFileSelected,
      onRemove: _onRemoveCsv,
    );
  }

  Widget _buildImagesPicker() {
    return BulkImportFilePicker(
      title: 'Product Images ZIP',
      required: false,
      selectedFileName: _importData.imagesZipFileName,
      helperText: _zipHelperText,
      icon: Icons.folder_zip_outlined,
      allowedFormats: const ['ZIP'],
      onFileSelected: _onImagesZipFileSelected,
      onRemove: _onRemoveImagesZip,
    );
  }

  // ===========================================================================
  // CSV FILE SELECTED
  // ===========================================================================

  void _onCsvFileSelected(PlatformFile file) {
    if (_importData.isImporting) {
      return;
    }

    final fileName = file.name.trim();

    if (fileName.isEmpty) {
      _showSnackBar('Invalid CSV file selected.');
      return;
    }

    if (!fileName.toLowerCase().endsWith('.csv')) {
      _showSnackBar('Please select a valid CSV file.');
      return;
    }

    setState(() {
      _selectedCsvFile = file;

      _importData = _importData.copyWith(
        status: BulkImportStatus.ready,
        csvFileName: fileName,
        clearErrorMessage: true,
        processedRows: 0,
        totalRows: 0,
        successCount: 0,
        failedCount: 0,
      );

      _lastProcessResult = null;
    });

    debugPrint('========== CSV FILE SELECTED ==========');
    debugPrint('NAME: ${file.name}');
    debugPrint('PATH: ${file.path}');
    debugPrint('=======================================');

    _showSnackBar('CSV file selected successfully.');
  }

  // ===========================================================================
  // ZIP FILE SELECTED
  // ===========================================================================

  void _onImagesZipFileSelected(PlatformFile file) {
    if (_importData.isImporting) {
      return;
    }

    final fileName = file.name.trim();

    if (fileName.isEmpty) {
      _showSnackBar('Invalid ZIP file selected.');
      return;
    }

    if (!fileName.toLowerCase().endsWith('.zip')) {
      _showSnackBar('Please select a valid ZIP file.');
      return;
    }

    setState(() {
      _selectedImagesZipFile = file;

      _importData = _importData.copyWith(imagesZipFileName: fileName);
    });

    debugPrint('========== IMAGE ZIP SELECTED ==========');
    debugPrint('NAME: ${file.name}');
    debugPrint('PATH: ${file.path}');
    debugPrint('========================================');

    _showSnackBar('Images ZIP selected successfully.');
  }

  // ===========================================================================
  // IMPORT ACTION
  // ===========================================================================

  Widget _buildImportActionSection() {
    final isImporting = _importData.status == BulkImportStatus.importing;

    final canImport =
        _selectedCsvFile != null && _importData.hasCsvFile && !isImporting;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          title: 'Start Import',
          description: 'Review your files and start importing your products.',
        ),
        const SizedBox(height: 12),
        BulkImportActionButtons(
          onStartImport: canImport ? _onStartImport : null,
          onReset: isImporting ? null : _onReset,
          isLoading: isImporting,
          isEnabled: canImport,
          showReset: true,
        ),
      ],
    );
  }

  // ===========================================================================
  // OPTIONAL COLUMNS
  // ===========================================================================

  Widget _buildOptionalColumns() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tune_rounded,
                size: 19,
                color: AppColors.iconSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Optional Columns',
                  style: AppTextStyles.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'These columns can be added when you need additional '
            'product information.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: _optionalColumns
                .map((column) => _OptionalColumnChip(label: column))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION TITLE
  // ===========================================================================

  Widget _buildSectionTitle({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMedium),
        const SizedBox(height: 3),
        Text(description, style: AppTextStyles.bodySmall),
      ],
    );
  }

  // ===========================================================================
  // REMOVE CSV
  // ===========================================================================

  void _onRemoveCsv() {
    if (_importData.isImporting) {
      return;
    }

    setState(() {
      _selectedCsvFile = null;

      _importData = _importData.copyWith(
        status: BulkImportStatus.idle,
        clearCsvFile: true,
        clearErrorMessage: true,
        processedRows: 0,
        totalRows: 0,
        successCount: 0,
        failedCount: 0,
      );

      _lastProcessResult = null;
    });

    _showSnackBar('CSV file removed.');
  }

  // ===========================================================================
  // REMOVE ZIP
  // ===========================================================================

  void _onRemoveImagesZip() {
    if (_importData.isImporting) {
      return;
    }

    setState(() {
      _selectedImagesZipFile = null;

      _importData = _importData.copyWith(clearImagesZipFile: true);
    });

    _showSnackBar('Images ZIP removed.');
  }

  // ===========================================================================
  // ARABIC TOGGLE
  // ===========================================================================

  void _onArabicChanged(bool value) {
    if (_importData.isImporting) {
      return;
    }

    setState(() {
      _importData = _importData.copyWith(autoGenerateArabic: value);
    });
  }

  // ===========================================================================
  // START IMPORT
  // ===========================================================================

Future<void> _onStartImport() async {
  if (_importData.isImporting) {
    return;
  }

  final csvFile = _selectedCsvFile;

  if (csvFile == null) {
    _showSnackBar('Please select a CSV file first.');
    return;
  }

  if (!_importData.hasCsvFile) {
    _showSnackBar('Please select a CSV file first.');
    return;
  }

  final csvFileName = csvFile.name.trim();
  final csvFilePath = csvFile.path?.trim();

  if (csvFileName.isEmpty) {
    _showSnackBar('Selected CSV file is invalid.');
    return;
  }

  if (csvFilePath == null || csvFilePath.isEmpty) {
    _showSnackBar(
      'Unable to access the selected CSV file. '
      'Please select it again.',
    );
    return;
  }

  // ============================================================
  // SET IMPORTING STATE
  // ============================================================

  setState(() {
    _lastProcessResult = null;

    _importData = _importData.copyWith(
      status: BulkImportStatus.importing,
      processedRows: 0,
      totalRows: 0,
      successCount: 0,
      failedCount: 0,
      clearErrorMessage: true,
    );
  });

  _showSnackBar(
    'Uploading CSV and starting import...',
  );

  try {
    debugPrint('');
    debugPrint('========== IMPORT START REQUEST ==========');
    debugPrint('CSV FILE NAME: $csvFileName');
    debugPrint('CSV FILE PATH: $csvFilePath');
    debugPrint(
      'TRANSLATE AR: '
      '${_importData.autoGenerateArabic ? '1' : '0'}',
    );
    debugPrint('==========================================');

    // ==========================================================
    // STEP 1
    // Upload CSV + Start Import
    // ==========================================================

    final startResult =
        await _importStartController.startImport(
      csvFile: csvFile,
      translateAr: _importData.autoGenerateArabic,
    );

    if (!mounted) {
      return;
    }

    debugPrint('');
    debugPrint('========== IMPORT START RESPONSE ==========');
    debugPrint('SUCCESS: ${startResult.success}');
    debugPrint('MESSAGE: ${startResult.message}');
    debugPrint('JOB ID: ${startResult.jobId}');
    debugPrint('===========================================');

    // ==========================================================
    // API RETURNED FAILURE
    // ==========================================================

    if (!startResult.success) {
      _setImportFailed(
        startResult.displayMessage,
      );

      _showSnackBar(
        startResult.displayMessage,
      );

      return;
    }

    // ==========================================================
    // VALIDATE JOB ID
    // ==========================================================

    final jobId = startResult.jobId?.trim();

    if (jobId == null || jobId.isEmpty) {
      const message =
          'Import job ID was not returned by server.';

      _setImportFailed(message);
      _showSnackBar(message);

      return;
    }

    // ==========================================================
    // STEP 2
    // PROCESS IMPORT
    // ==========================================================

    _showSnackBar(
      'CSV uploaded successfully. Processing products...',
    );

    await _processImportJob(jobId);
  } on ApiException catch (error) {
    if (!mounted) {
      return;
    }

    _setImportFailed(error.message);

    _showSnackBar(error.message);

    debugPrint(
      'IMPORT API ERROR: ${error.message}',
    );
  } catch (error) {
    if (!mounted) {
      return;
    }

    const message =
        'Unable to import products. Please try again.';

    _setImportFailed(message);

    _showSnackBar(message);

    debugPrint(
      'IMPORT ERROR: $error',
    );
  }
}
  // ===========================================================================
  // PROCESS IMPORT JOB
  // ===========================================================================

  Future<void> _processImportJob(String jobId) async {
    var attempts = 0;

    while (mounted) {
      attempts++;

      if (attempts > _maxProcessAttempts) {
        const message =
            'Import processing is taking longer than expected. '
            'Please try again later.';

        _setImportFailed(message);

        _showSnackBar(message);

        debugPrint('IMPORT PROCESS STOPPED: Maximum attempts reached.');

        return;
      }

      try {
        final processResult = await _importProcessController.processImport(
          jobId: jobId,
        );

        if (!mounted) {
          return;
        }

        _lastProcessResult = processResult;

        _updateProgressFromApi(processResult);

        debugPrint('');
        debugPrint('========== IMPORT PROCESS ==========');
        debugPrint('ATTEMPT: $attempts');
        debugPrint('SUCCESS: ${processResult.success}');
        debugPrint('MESSAGE: ${processResult.message}');
        debugPrint('JOB ID: ${processResult.jobId}');
        debugPrint('OFFSET: ${processResult.offset}');
        debugPrint('TOTAL: ${processResult.total}');
        debugPrint('CREATED: ${processResult.created}');
        debugPrint('SKIPPED: ${processResult.skipped}');
        debugPrint('DONE: ${processResult.done}');
        debugPrint('ERRORS: ${processResult.errors}');
        debugPrint('====================================');

        // =====================================================================
        // Backend failure
        // =====================================================================

        if (!processResult.success) {
          _setImportFailed(processResult.displayMessage);

          _showSnackBar(processResult.displayMessage);

          return;
        }

        // =====================================================================
        // Validate job
        // =====================================================================

        if (!processResult.hasJob) {
          const message =
              'Invalid import process response received from server.';

          _setImportFailed(message);

          _showSnackBar(message);

          debugPrint('IMPORT PROCESS ERROR: Job object is missing.');

          return;
        }

        // =====================================================================
        // Validate job ID
        // =====================================================================

        final responseJobId = processResult.jobId?.trim();

        if (responseJobId == null || responseJobId.isEmpty) {
          const message =
              'Import job information is missing from server response.';

          _setImportFailed(message);

          _showSnackBar(message);

          debugPrint('IMPORT PROCESS ERROR: Job ID missing.');

          return;
        }

        if (responseJobId != jobId) {
          const message = 'Import job mismatch received from server.';

          _setImportFailed(message);

          _showSnackBar(message);

          debugPrint(
            'IMPORT PROCESS ERROR: '
            'Expected $jobId but received $responseJobId',
          );

          return;
        }

        // =====================================================================
        // Completed
        // =====================================================================

        if (processResult.done) {
          _completeImport(processResult);

          if (processResult.hasErrors) {
            _showSnackBar(
              'Import completed with '
              '${processResult.errors.length} failed row(s).',
            );
          } else {
            _showSnackBar(processResult.displayMessage);
          }

          return;
        }

        // =====================================================================
        // More processing required
        // =====================================================================

        await Future<void>.delayed(_processDelay);
      } on ApiException catch (error) {
        if (!mounted) {
          return;
        }

        _setImportFailed(error.message);

        _showSnackBar(error.message);

        debugPrint('IMPORT PROCESS API ERROR: ${error.message}');

        return;
      } catch (error) {
        if (!mounted) {
          return;
        }

        const message = 'Unable to process import. Please try again.';

        _setImportFailed(message);

        _showSnackBar(message);

        debugPrint('IMPORT PROCESS ERROR: $error');

        return;
      }
    }
  }

  // ===========================================================================
  // API → UI MAPPING
  // ===========================================================================

  void _updateProgressFromApi(ImportProcessModel result) {
    if (!mounted) {
      return;
    }

    setState(() {
      _importData = _importData.copyWith(
        status: BulkImportStatus.importing,
        totalRows: result.total,
        processedRows: result.offset,
        successCount: result.created,
        failedCount: result.skipped,
        errorMessage: result.hasErrors ? result.errors.join('\n') : null,
      );
    });
  }

  void _completeImport(ImportProcessModel result) {
    if (!mounted) {
      return;
    }

    setState(() {
      _importData = _importData.copyWith(
        status: BulkImportStatus.completed,
        totalRows: result.total,
        processedRows: result.offset,
        successCount: result.created,
        failedCount: result.skipped,
        errorMessage: result.hasErrors ? result.errors.join('\n') : null,
      );
    });
  }

  void _setImportFailed(String message) {
    if (!mounted) {
      return;
    }

    setState(() {
      _importData = _importData.copyWith(
        status: BulkImportStatus.failed,
        errorMessage: message,
      );
    });
  }

  // ===========================================================================
  // FAILED ROWS
  // ===========================================================================

  void _onViewErrors() {
    final errors = _lastProcessResult?.errors ?? const <String>[];

    if (errors.isEmpty) {
      _showSnackBar('No failed row details were returned by the server.');
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Failed Rows', style: AppTextStyles.titleMedium),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 420),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${errors.length} row(s) could not be imported.',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 14),
                  ...errors.asMap().entries.map((entry) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        entry.value,
                        style: AppTextStyles.captionMedium.copyWith(
                          color: AppColors.errorDark,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // RESET
  // ===========================================================================

  Future<void> _onReset() async {
    if (_importData.isImporting) {
      return;
    }

    final confirmed = await BulkImportResetDialog.show(context);

    if (!mounted || confirmed != true) {
      return;
    }

    setState(() {
      _selectedCsvFile = null;
      _selectedImagesZipFile = null;
      _lastProcessResult = null;
      _importData = const BulkImportModel();
    });

    _showSnackBar('Import setup has been reset.');
  }

  // ===========================================================================
  // DONE
  // ===========================================================================

  void _onImportDone() {
    if (_importData.isImporting) {
      return;
    }

    setState(() {
      _selectedCsvFile = null;
      _selectedImagesZipFile = null;
      _lastProcessResult = null;
      _importData = const BulkImportModel();
    });

    _showSnackBar('Import setup has been reset.');
  }

  // ===========================================================================
  // DOWNLOAD CSV
  // ===========================================================================

  Future<void> _onDownloadCsvTemplate() async {
    if (!mounted) {
      return;
    }

    _showSnackBar('Downloading CSV template...');

    try {
      final result = await _controller.downloadSampleCsv();

      if (!mounted) {
        return;
      }

      const fileName = 'gatbi_product_sample.csv';

      final file = await const FileDownloadService().saveTextFile(
        content: result.content,
        fileName: fileName,
      );

      if (!mounted) {
        return;
      }

      _showSnackBar('CSV template downloaded successfully.');

      debugPrint('CSV FILE PATH: ${file.path}');
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showSnackBar(error.message);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showSnackBar('Unable to download CSV template. Please try again.');

      debugPrint('CSV DOWNLOAD ERROR: $error');
    }
  }

  // ===========================================================================
  // DOWNLOAD XLSX
  // ===========================================================================

  Future<void> _onDownloadExcelTemplate() async {
    if (!mounted) {
      return;
    }

    _showSnackBar('Downloading Excel template...');

    try {
      final result = await _xlsxController.downloadSampleXlsx();

      if (!mounted) {
        return;
      }

      const fileName = 'gatbi_product_template.xlsx';

      final file = await const FileDownloadService().saveBytesFile(
        bytes: result.bytes,
        fileName: fileName,
        mimeType:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );

      if (!mounted) {
        return;
      }

      _showSnackBar('Excel template downloaded successfully.');

      debugPrint('XLSX FILE PATH: ${file.path}');
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showSnackBar(error.message);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showSnackBar('Unable to download Excel template. Please try again.');

      debugPrint('XLSX DOWNLOAD ERROR: $error');
    }
  }

  // ===========================================================================
  // HELP
  // ===========================================================================

  void _showHelpDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                  color: AppColors.primary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Bulk Import Help',
                  style: AppTextStyles.titleMedium,
                ),
              ),
            ],
          ),
          content: const BulkImportInfoCard(
            title: 'Before you import',
            description:
                'Prepare a UTF-8 CSV file with all required '
                'columns. If you are uploading product images, '
                'add them to a ZIP file and use matching file '
                'names in your CSV.',
            type: BulkImportInfoType.info,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // SNACKBAR
  // ===========================================================================

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }
}

// =============================================================================
// RESOURCE BUTTON
// =============================================================================

class _ResourceButton extends StatelessWidget {
  const _ResourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceSoft,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 17, color: AppColors.primary),
              const SizedBox(width: 7),
              Text(
                label,
                style: AppTextStyles.captionMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// OPTIONAL COLUMN CHIP
// =============================================================================

class _OptionalColumnChip extends StatelessWidget {
  const _OptionalColumnChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label, style: AppTextStyles.captionMedium),
    );
  }
}
