import 'import_process_job_model.dart';

class ImportProcessModel {
  const ImportProcessModel({this.success = false, this.message, this.job});

  /// Whether the import process completed successfully.
  final bool success;

  /// Backend response message.
  final String? message;

  /// Import job details.
  final ImportProcessJobModel? job;

  factory ImportProcessModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ImportProcessModel();
    }

    final rawJob = json['job'];

    return ImportProcessModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      job: rawJob is Map
          ? ImportProcessJobModel.fromJson(Map<String, dynamic>.from(rawJob))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'job': job?.toJson(),
    };
  }

  /// Whether the process was successful and job exists.
  bool get isCompleted {
    return success && job?.done == true;
  }

  /// Whether a job object was returned.
  bool get hasJob => job != null;

  /// Whether the response contains import errors.
  bool get hasErrors {
    return job?.hasErrors ?? false;
  }

  /// Safe message for UI.
  String get displayMessage {
    final value = message?.trim();

    if (value == null || value.isEmpty) {
      return success
          ? 'Import completed successfully.'
          : 'Unable to process import.';
    }

    return value;
  }

  /// Convenience access to job ID.
  String? get jobId => job?.jobId;

  /// Convenience access to total rows.
  int get total => job?.total ?? 0;

  /// Convenience access to created rows.
  int get created => job?.created ?? 0;

  /// Convenience access to skipped rows.
  int get skipped => job?.skipped ?? 0;

  /// Convenience access to current offset.
  int get offset => job?.offset ?? 0;

  /// Convenience access to completion state.
  bool get done => job?.done ?? false;

  /// Convenience access to errors.
  List<String> get errors => job?.errors ?? const [];

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

    final result = value.toString().trim();

    if (result.isEmpty) {
      return null;
    }

    return result;
  }
}
