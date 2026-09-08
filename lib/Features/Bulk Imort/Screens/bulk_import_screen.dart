import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

import '../Data/dummy_bulk_import_data.dart';
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

class BulkImportScreen extends StatefulWidget {
  const BulkImportScreen({super.key});

  @override
  State<BulkImportScreen> createState() => _BulkImportScreenState();
}

class _BulkImportScreenState extends State<BulkImportScreen> {
  BulkImportModel _importData = DummyBulkImportData.initial;

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

  // ─────────────────────────────────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: BulkImportHeader(
        onBack: () {
          Navigator.of(context).maybePop();
        },
        onHelp: _showHelpDialog,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CONTENT
  // ─────────────────────────────────────────────────────────────────────────

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
            description: DummyBulkImportData.arabicDescription,
          ),

          const SizedBox(height: 20),

          _buildImportActionSection(),

          const SizedBox(height: 22),

          BulkImportRequiredColumns(
            columns: DummyBulkImportData.requiredColumns,
            title: 'Required CSV Columns',
            description: 'Make sure your CSV contains all required columns.',
          ),

          const SizedBox(height: 14),

          _buildOptionalColumns(),

          const SizedBox(height: 14),

          BulkImportImageHelp(),

          const SizedBox(height: 18),

          BulkImportProgressCard(
            importData: _importData,
            onViewErrors: _onViewErrors,
            onDone: _onImportDone,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // INTRO
  // ─────────────────────────────────────────────────────────────────────────

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

  // ─────────────────────────────────────────────────────────────────────────
  // RESOURCES
  // ─────────────────────────────────────────────────────────────────────────

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
              _ResourceButton(
                icon: Icons.image_outlined,
                label: 'Image Sample',
                onTap: _onDownloadImageSample,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FILE PICKERS
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildCsvPicker() {
    return BulkImportFilePicker(
      title: 'Product CSV',
      required: true,
      selectedFileName: _importData.csvFileName,
      helperText: DummyBulkImportData.csvHelperText,
      allowedFormats: const ['CSV'],
      icon: Icons.table_chart_outlined,
      onPick: _onPickCsv,
      onRemove: _onRemoveCsv,
    );
  }

  Widget _buildImagesPicker() {
    return BulkImportFilePicker(
      title: 'Product Images ZIP',
      required: false,
      selectedFileName: _importData.imagesZipFileName,
      helperText: DummyBulkImportData.zipHelperText,
      allowedFormats: const ['ZIP'],
      icon: Icons.folder_zip_outlined,
      onPick: _onPickImagesZip,
      onRemove: _onRemoveImagesZip,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ACTION SECTION
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildImportActionSection() {
    final bool isImporting = _importData.status == BulkImportStatus.importing;

    final bool canImport = _importData.hasCsvFile && !isImporting;

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

  // ─────────────────────────────────────────────────────────────────────────
  // OPTIONAL COLUMNS
  // ─────────────────────────────────────────────────────────────────────────

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
            children: DummyBulkImportData.optionalColumns
                .map((column) => _OptionalColumnChip(label: column))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SECTION TITLE
  // ─────────────────────────────────────────────────────────────────────────

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

  // ─────────────────────────────────────────────────────────────────────────
  // FILE CALLBACKS
  // ─────────────────────────────────────────────────────────────────────────

  void _onPickCsv() {
    // UI-only placeholder.
    //
    // Later:
    // 1. Open file picker.
    // 2. Validate CSV.
    // 3. Send selected file name/path to controller.
    //
    // Keeping this callback here means the UI does not need
    // to know anything about the file-picker implementation.

    setState(() {
      _importData = _importData.copyWith(
        status: BulkImportStatus.ready,
        csvFileName: DummyBulkImportData.sampleCsvFileName,
      );
    });

    _showSnackBar('CSV file selected.');
  }

  void _onPickImagesZip() {
    // UI-only placeholder for ZIP file picker.

    setState(() {
      _importData = _importData.copyWith(
        status: BulkImportStatus.ready,
        imagesZipFileName: DummyBulkImportData.sampleImagesZipFileName,
      );
    });

    _showSnackBar('Images ZIP selected.');
  }

  void _onRemoveCsv() {
    setState(() {
      _importData = _importData.copyWith(
        status: BulkImportStatus.idle,
        clearCsvFile: true,
      );
    });
  }

  void _onRemoveImagesZip() {
    setState(() {
      _importData = _importData.copyWith(clearImagesZipFile: true);
    });
  }

  void _onArabicChanged(bool value) {
    setState(() {
      _importData = _importData.copyWith(autoGenerateArabic: value);
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // IMPORT
  // ─────────────────────────────────────────────────────────────────────────

  void _onStartImport() {
    if (!_importData.hasCsvFile) {
      _showSnackBar('Please select a CSV file first.');
      return;
    }

    // UI-only demo state.
    //
    // Later this will be replaced by:
    // controller.startImport(...)
    //
    // No API implementation is intentionally added here.

    setState(() {
      _importData = DummyBulkImportData.importing.copyWith(
        csvFileName: _importData.csvFileName,
        imagesZipFileName: _importData.imagesZipFileName,
        autoGenerateArabic: _importData.autoGenerateArabic,
      );
    });

    _showSnackBar('Import started.');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // RESET
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _onReset() async {
    final bool? confirmed = await BulkImportResetDialog.show(context);

    if (!mounted || confirmed != true) {
      return;
    }

    setState(() {
      _importData = DummyBulkImportData.initial;
    });

    _showSnackBar('Import setup has been reset.');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // IMPORT RESULT CALLBACKS
  // ─────────────────────────────────────────────────────────────────────────

  void _onViewErrors() {
    _showSnackBar('Failed rows will be available here after API integration.');
  }

  void _onImportDone() {
    setState(() {
      _importData = DummyBulkImportData.initial;
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // RESOURCE CALLBACKS
  // ─────────────────────────────────────────────────────────────────────────

  void _onDownloadCsvTemplate() {
    _showSnackBar('CSV template download will be connected later.');
  }

  void _onDownloadExcelTemplate() {
    _showSnackBar('Excel template download will be connected later.');
  }

  void _onDownloadImageSample() {
    _showSnackBar('Image sample download will be connected later.');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HELP
  // ─────────────────────────────────────────────────────────────────────────

  void _showHelpDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
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
                Navigator.of(context).pop();
              },
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SNACKBAR
  // ─────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────
// RESOURCE BUTTON
// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────
// OPTIONAL COLUMN CHIP
// ─────────────────────────────────────────────────────────────────────────────

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
