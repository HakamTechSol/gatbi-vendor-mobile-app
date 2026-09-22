import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio_client.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/vendor_kyc_document_model.dart';

class KycDocumentPreviewDialog extends StatefulWidget {
  const KycDocumentPreviewDialog({
    super.key,
    required this.document,
    required this.dioClient,
  });

  final VendorKycDocumentModel document;
  final DioClient dioClient;

  @override
  State<KycDocumentPreviewDialog> createState() =>
      _KycDocumentPreviewDialogState();
}

class _KycDocumentPreviewDialogState extends State<KycDocumentPreviewDialog> {
  // ============================================================
  // STATE
  // ============================================================

  Uint8List? _fileBytes;

  bool _isLoading = true;

  String? _errorMessage;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadDocument();
  }

  // ============================================================
  // LOAD DOCUMENT
  // ============================================================

  Future<void> _loadDocument() async {
    final fileUrl = widget.document.fileUrl?.trim();

    if (fileUrl == null || fileUrl.isEmpty) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Document URL is not available.';
      });

      return;
    }

    try {
      // ==========================================================
      // NORMALIZE DOCUMENT ENDPOINT
      // ==========================================================
      //
      // DioClient baseUrl:
      //
      // https://gatbi.ae/api/mobile/
      //
      // Backend file URL:
      //
      // /api/mobile/vendor/kyc/document/11
      //
      // Required Dio endpoint:
      //
      // vendor/kyc/document/11
      //
      // ==========================================================

      final endpoint = _normalizeDocumentEndpoint(fileUrl);

      debugPrint('');
      debugPrint('========== KYC DOCUMENT REQUEST ==========');
      debugPrint('ORIGINAL URL: $fileUrl');
      debugPrint('NORMALIZED ENDPOINT: $endpoint');
      debugPrint('==========================================');
      debugPrint('');

      // ==========================================================
      // GET FILE BYTES
      // ==========================================================

      final response = await widget.dioClient.get<List<int>>(
        endpoint,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Accept': '*/*'},
        ),
      );

      if (!mounted) return;

      final data = response.data;

      // ==========================================================
      // EMPTY FILE CHECK
      // ==========================================================

      if (data == null || data.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Document file is empty.';
        });

        return;
      }

      // ==========================================================
      // SUCCESS
      // ==========================================================

      final bytes = Uint8List.fromList(data);

      setState(() {
        _fileBytes = bytes;
        _isLoading = false;
        _errorMessage = null;
      });

      debugPrint('');
      debugPrint('========== KYC DOCUMENT SUCCESS ==========');
      debugPrint('BYTES: ${bytes.length}');
      debugPrint('==========================================');
      debugPrint('');
    } catch (error) {
      if (!mounted) return;

      debugPrint('');
      debugPrint('========== KYC DOCUMENT ERROR ==========');
      debugPrint('ERROR: $error');
      debugPrint('========================================');
      debugPrint('');

      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(error);
      });
    }
  }

  // ============================================================
  // NORMALIZE DOCUMENT ENDPOINT
  // ============================================================

  String _normalizeDocumentEndpoint(String fileUrl) {
    var url = fileUrl.trim();

    // ------------------------------------------------------------
    // CASE 1:
    // Full URL
    //
    // https://gatbi.ae/api/mobile/vendor/kyc/document/11
    // ------------------------------------------------------------

    if (url.startsWith('https://') || url.startsWith('http://')) {
      final uri = Uri.tryParse(url);

      if (uri != null) {
        url = uri.path;
      }
    }

    // ------------------------------------------------------------
    // Remove leading slash
    //
    // /api/mobile/vendor/kyc/document/11
    // ->
    // api/mobile/vendor/kyc/document/11
    // ------------------------------------------------------------

    url = url.replaceFirst(RegExp(r'^/+'), '');

    // ------------------------------------------------------------
    // Remove API base path because DioClient already has:
    //
    // https://gatbi.ae/api/mobile/
    //
    // ------------------------------------------------------------

    const apiPrefix = 'api/mobile/';

    if (url.startsWith(apiPrefix)) {
      url = url.substring(apiPrefix.length);
    }

    return url;
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String _getErrorMessage(Object error) {
    if (error is DioException) {
      final dioError = error.error;

      // ----------------------------------------------------------
      // ApiException from DioClient interceptor
      // ----------------------------------------------------------

      if (dioError is ApiException) {
        final message = dioError.message.trim();

        if (message.isNotEmpty) {
          return message;
        }
      }

      // ----------------------------------------------------------
      // HTTP STATUS
      // ----------------------------------------------------------

      final statusCode = error.response?.statusCode;

      if (statusCode == 401) {
        return 'Your session has expired. Please login again.';
      }

      if (statusCode == 403) {
        return 'You do not have permission to view this document.';
      }

      if (statusCode == 404) {
        return 'Document was not found.';
      }

      if (statusCode != null && statusCode >= 500) {
        return 'Server error. Please try again later.';
      }
    }

    return 'Unable to load this document.';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),

            const Divider(height: 1),

            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 10, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(_documentTitle(), style: AppTextStyles.titleMedium),
          ),

          IconButton(
            tooltip: 'Close',
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody() {
    // ----------------------------------------------------------
    // Loading
    // ----------------------------------------------------------

    if (_isLoading) {
      return _buildLoading();
    }

    // ----------------------------------------------------------
    // Error
    // ----------------------------------------------------------

    if (_errorMessage != null) {
      return _buildError();
    }

    // ----------------------------------------------------------
    // Empty
    // ----------------------------------------------------------

    final bytes = _fileBytes;

    if (bytes == null || bytes.isEmpty) {
      return _buildUnavailable();
    }

    // ----------------------------------------------------------
    // PDF
    // ----------------------------------------------------------

    if (_isPdfBytes(bytes)) {
      return _buildPdfPlaceholder();
    }

    // ----------------------------------------------------------
    // IMAGE
    // ----------------------------------------------------------

    return _buildImage(bytes);
  }

  // ============================================================
  // IMAGE
  // ============================================================

  Widget _buildImage(Uint8List bytes) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.background,
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          boundaryMargin: const EdgeInsets.all(40),
          child: Image.memory(
            bytes,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('KYC IMAGE DECODE ERROR: $error');

              return _buildUnavailable();
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),

          const SizedBox(height: 14),

          Text('Loading document...', style: AppTextStyles.titleSmall),

          const SizedBox(height: 5),

          Text(
            'Please wait while the document is being loaded.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 30,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'Preview Unavailable',
            style: AppTextStyles.titleMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          Text(
            _errorMessage ?? 'Unable to load this document.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          OutlinedButton.icon(
            onPressed: _retry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RETRY
  // ============================================================

  void _retry() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _fileBytes = null;
    });

    _loadDocument();
  }

  // ============================================================
  // UNAVAILABLE
  // ============================================================

  Widget _buildUnavailable() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.broken_image_outlined,
            size: 52,
            color: AppColors.iconSecondary,
          ),

          const SizedBox(height: 12),

          Text('Preview Unavailable', style: AppTextStyles.titleMedium),

          const SizedBox(height: 5),

          Text(
            'Unable to display this document.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PDF PLACEHOLDER
  // ============================================================

  Widget _buildPdfPlaceholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.picture_as_pdf_rounded,
            size: 60,
            color: AppColors.error,
          ),

          const SizedBox(height: 12),

          Text('PDF Document', style: AppTextStyles.titleMedium),

          const SizedBox(height: 6),

          Text(
            'The PDF has been loaded successfully.\n'
            'A PDF viewer is required to display it.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DOCUMENT TITLE
  // ============================================================

  String _documentTitle() {
    final type = widget.document.documentType?.trim();

    if (type == null || type.isEmpty) {
      return 'Document Preview';
    }

    return type
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}'
                    '${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  // ============================================================
  // PDF DETECTION
  // ============================================================
  //
  // PDF files normally start with:
  //
  // %PDF
  //
  // This works even when the API URL does not contain ".pdf".
  // ============================================================

  bool _isPdfBytes(Uint8List bytes) {
    if (bytes.length < 4) {
      return false;
    }

    return bytes[0] == 0x25 && // %
        bytes[1] == 0x50 && // P
        bytes[2] == 0x44 && // D
        bytes[3] == 0x46; // F
  }
}
