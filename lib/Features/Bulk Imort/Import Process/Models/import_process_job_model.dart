class ImportProcessJobModel {
  const ImportProcessJobModel({
    this.jobId,
    this.offset = 0,
    this.total = 0,
    this.created = 0,
    this.skipped = 0,
    this.done = false,
    this.errors = const [],
  });

  /// Unique import job identifier.
  final String? jobId;

  /// Current processing offset.
  final int offset;

  /// Total rows/items in the import job.
  final int total;

  /// Number of products created.
  final int created;

  /// Number of rows skipped.
  final int skipped;

  /// Whether the import job is completed.
  final bool done;

  /// Import row-level errors.
  final List<String> errors;

  factory ImportProcessJobModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ImportProcessJobModel();
    }

    return ImportProcessJobModel(
      jobId: _parseString(json['job_id']),
      offset: _parseInt(json['offset']),
      total: _parseInt(json['total']),
      created: _parseInt(json['created']),
      skipped: _parseInt(json['skipped']),
      done: _parseBool(json['done']),
      errors: _parseStringList(json['errors']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'job_id': jobId,
      'offset': offset,
      'total': total,
      'created': created,
      'skipped': skipped,
      'done': done,
      'errors': errors,
    };
  }

  /// Whether a valid job ID exists.
  bool get hasJobId {
    return jobId != null && jobId!.trim().isNotEmpty;
  }

  /// Whether any import errors were returned.
  bool get hasErrors => errors.isNotEmpty;

  /// Whether all rows have been processed.
  bool get isComplete => done;

  /// Number of rows successfully created.
  int get successfulCount => created;

  /// Number of rows that were skipped.
  int get skippedCount => skipped;

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

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value.trim()) ?? 0;
    }

    return 0;
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

  static List<String> _parseStringList(dynamic value) {
    if (value == null) {
      return const [];
    }

    if (value is List) {
      return value
          .map<String?>((item) {
            if (item == null) {
              return null;
            }

            final result = item.toString().trim();

            if (result.isEmpty) {
              return null;
            }

            return result;
          })
          .whereType<String>()
          .toList();
    }

    return const [];
  }
}
