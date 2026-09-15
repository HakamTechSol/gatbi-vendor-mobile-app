import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/kyc_document_file.dart';

class KycDocumentUploadCard extends StatelessWidget {
  const KycDocumentUploadCard({
    super.key,
    required this.title,
    required this.onUpload,
    this.onRemove,
    this.required = false,
    this.file,
    this.errorText,
    this.subtitle = 'JPG, PNG, WEBP or PDF • Max 8 MB',
  });

  final String title;
  final VoidCallback onUpload;
  final VoidCallback? onRemove;
  final bool required;
  final KycDocumentFile? file;
  final String? errorText;
  final String subtitle;

  bool get hasFile => file != null;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: errorText != null
              ? AppColors.error
              : hasFile
              ? AppColors.successBorder
              : AppColors.border,
          width: errorText != null || hasFile ? 1.2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          if (hasFile) ...[
            const SizedBox(height: 14),
            _buildFilePreview(context),
          ] else ...[
            const SizedBox(height: 13),
            Text(subtitle, style: AppTextStyles.caption),
          ],

          const SizedBox(height: 13),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: onUpload,
                    icon: Icon(
                      hasFile
                          ? Icons.change_circle_outlined
                          : Icons.upload_file_outlined,
                      size: 19,
                    ),
                    label: Text(
                      hasFile ? 'Change Document' : 'Upload Document',
                    ),
                  ),
                ),
              ),

              if (hasFile && onRemove != null) ...[
                const SizedBox(width: 8),

                SizedBox(
                  width: 44,
                  height: 44,
                  child: IconButton(
                    onPressed: onRemove,
                    tooltip: 'Remove document',
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.error.withOpacity(0.08),
                      foregroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  ),
                ),
              ],
            ],
          ),

          if (errorText != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 15,
                  color: AppColors.error,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(errorText!, style: AppTextStyles.formError),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: hasFile ? AppColors.successLight : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            hasFile
                ? Icons.check_circle_outline_rounded
                : Icons.description_outlined,
            color: hasFile ? AppColors.success : AppColors.primary,
            size: 21,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title${required ? ' *' : ''}',
                style: AppTextStyles.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                hasFile
                    ? '${file!.name} • ${file!.formattedSize}'
                    : 'Required document',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilePreview(BuildContext context) {
    if (file!.isImage) {
      return GestureDetector(
        onTap: () => _showImagePreview(context),
        child: Container(
          height: 145,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(file!.path),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _buildFileFallback(
                    Icons.broken_image_outlined,
                    'Unable to preview image',
                  );
                },
              ),

              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.58),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.visibility_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Tap to view',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _buildFileFallback(
      Icons.picture_as_pdf_outlined,
      'PDF document attached',
    );
  }

  Widget _buildFileFallback(IconData icon, String text) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: AppColors.primary, size: 23),
          ),
          const SizedBox(width: 12),
          Text(text, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  void _showImagePreview(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4,
                  child: Image.file(File(file!.path), fit: BoxFit.contain),
                ),
              ),

              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.55),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
