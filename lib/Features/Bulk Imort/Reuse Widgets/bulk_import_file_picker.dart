import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class BulkImportFilePicker extends StatefulWidget {
  const BulkImportFilePicker({
    super.key,
    required this.title,
    this.helperText,
    this.selectedFileName,
    this.onPick,
    this.onRemove,
    this.icon = Icons.insert_drive_file_outlined,
    this.required = false,
    this.allowedFormats,
    this.onFileSelected,
  });

  final String title;
  final String? helperText;
  final String? selectedFileName;

  final VoidCallback? onPick;
  final VoidCallback? onRemove;

  /// Called after the actual file has been selected.
  ///
  /// This gives the parent screen the complete [PlatformFile]
  /// so it can later upload the file through the API.
  final ValueChanged<PlatformFile>? onFileSelected;

  final IconData icon;
  final bool required;

  /// Example:
  /// const ['csv']
  /// const ['zip']
  final List<String>? allowedFormats;

  @override
  State<BulkImportFilePicker> createState() =>
      _BulkImportFilePickerState();
}

class _BulkImportFilePickerState
    extends State<BulkImportFilePicker> {
  bool _isPicking = false;

  bool get hasFile {
    final value = widget.selectedFileName?.trim();

    return value != null && value.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),

        const SizedBox(height: 9),

        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: hasFile
                ? AppColors.primarySurface
                : AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasFile
                  ? AppColors.borderPrimary
                  : AppColors.border,
            ),
          ),
          child: hasFile
              ? _buildSelectedFile()
              : _buildEmptyState(),
        ),

        if (widget.helperText != null) ...[
          const SizedBox(height: 7),
          Text(
            widget.helperText!,
            style: AppTextStyles.formHelper,
          ),
        ],

        if (widget.allowedFormats != null &&
            widget.allowedFormats!.isNotEmpty) ...[
          const SizedBox(height: 9),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.allowedFormats!
                .map(
                  (format) => _FormatChip(
                    label: format.toUpperCase(),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  // ===========================================================================
  // LABEL
  // ===========================================================================

  Widget _buildLabel() {
    return Row(
      children: [
        Text(
          widget.title,
          style: AppTextStyles.formLabel,
        ),

        if (widget.required) ...[
          const SizedBox(width: 3),
          Text(
            '*',
            style: AppTextStyles.formLabel.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }

  // ===========================================================================
  // EMPTY STATE
  // ===========================================================================

  Widget _buildEmptyState() {
    return InkWell(
      onTap: _isPicking ? null : _pickFile,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: _isPicking
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  )
                : Icon(
                    widget.icon,
                    size: 22,
                    color: AppColors.primary,
                  ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  _isPicking
                      ? 'Opening Files...'
                      : 'Choose File',
                  style:
                      AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _isPicking
                      ? 'Please wait...'
                      : 'Tap to select a file',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          if (!_isPicking)
            const Icon(
              Icons.upload_file_rounded,
              size: 21,
              color: AppColors.iconSecondary,
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SELECTED FILE
  // ===========================================================================

  Widget _buildSelectedFile() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.successLight,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 23,
            color: AppColors.success,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                widget.selectedFileName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleSmall,
              ),
              const SizedBox(height: 3),
              Text(
                'File selected successfully',
                style:
                    AppTextStyles.captionMedium.copyWith(
                  color: AppColors.successDark,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 4),

        IconButton(
          onPressed: _isPicking
              ? null
              : widget.onRemove,
          tooltip: 'Remove file',
          icon: const Icon(
            Icons.close_rounded,
            size: 20,
            color: AppColors.iconSecondary,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // FILE PICKER
  // ===========================================================================

  Future<void> _pickFile() async {
    if (_isPicking) {
      return;
    }

    if (widget.allowedFormats == null ||
        widget.allowedFormats!.isEmpty) {
      await _pickAnyFile();
      return;
    }

    await _pickCustomFile();
  }

  Future<void> _pickCustomFile() async {
    setState(() {
      _isPicking = true;
    });

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions:
            _normalizedExtensions,
      );

      if (!mounted) {
        return;
      }

      if (result.isEmpty) {
        return;
      }

      final PlatformFile file = result.single;

      final String fileName = file.name.trim();

      if (fileName.isEmpty) {
        _showSnackBar(
          'Invalid file selected.',
        );
        return;
      }

      if (!_isValidExtension(fileName)) {
        _showSnackBar(
          'Please select a valid '
          '${_allowedExtensionsText}.',
        );
        return;
      }

      widget.onFileSelected?.call(file);

      widget.onPick?.call();
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint(
        'FILE PICKER PLATFORM ERROR: $error',
      );

      _showSnackBar(
        'Unable to open file picker.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint(
        'FILE PICKER ERROR: $error',
      );

      _showSnackBar(
        'Unable to select file. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  Future<void> _pickAnyFile() async {
    setState(() {
      _isPicking = true;
    });

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.any,
      );

      if (!mounted) {
        return;
      }

      if (result.isEmpty) {
        return;
      }

      final PlatformFile file = result.single;

      if (file.name.trim().isEmpty) {
        _showSnackBar(
          'Invalid file selected.',
        );
        return;
      }

      widget.onFileSelected?.call(file);

      widget.onPick?.call();
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint(
        'FILE PICKER PLATFORM ERROR: $error',
      );

      _showSnackBar(
        'Unable to open file picker.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint(
        'FILE PICKER ERROR: $error',
      );

      _showSnackBar(
        'Unable to select file. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  // ===========================================================================
  // VALIDATION
  // ===========================================================================

  List<String> get _normalizedExtensions {
    return widget.allowedFormats!
        .map(
          (format) => format
              .trim()
              .toLowerCase()
              .replaceFirst('.', ''),
        )
        .where((format) => format.isNotEmpty)
        .toSet()
        .toList();
  }

  String get _allowedExtensionsText {
    return _normalizedExtensions
        .map((extension) => '.$extension')
        .join(', ');
  }

  bool _isValidExtension(String fileName) {
    final lowerName = fileName.toLowerCase();

    return _normalizedExtensions.any(
      (extension) =>
          lowerName.endsWith('.$extension'),
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
          margin: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }
}

// =============================================================================
// FORMAT CHIP
// =============================================================================

class _FormatChip extends StatelessWidget {
  const _FormatChip({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.captionMedium,
      ),
    );
  }
}