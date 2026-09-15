class ImportStartModel {
  const ImportStartModel({this.success = false, this.message, this.jobId});

  /// Whether the import job was successfully started.
  final bool success;

  /// Backend response message.
  final String? message;

  /// Unique import job identifier.
  final String? jobId;

  factory ImportStartModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ImportStartModel();
    }

    return ImportStartModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      jobId: _parseString(json['job_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'job_id': jobId,
    };
  }

  /// Whether the backend successfully created the import job.
  bool get isStarted => success && hasJobId;

  /// Whether a valid job ID was returned.
  bool get hasJobId {
    return jobId != null && jobId!.trim().isNotEmpty;
  }

  /// Safe message for UI.
  String get displayMessage {
    final value = message?.trim();

    if (value == null || value.isEmpty) {
      return success
          ? 'Import job started successfully.'
          : 'Unable to start import job.';
    }

    return value;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();

      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }

    return false;
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    final stringValue = value.toString().trim();

    if (stringValue.isEmpty) {
      return null;
    }

    return stringValue;
  }
}
