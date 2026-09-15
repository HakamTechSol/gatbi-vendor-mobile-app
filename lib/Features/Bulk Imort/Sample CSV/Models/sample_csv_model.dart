class SampleCsvModel {
  const SampleCsvModel({this.content = ''});

  final String content;

  factory SampleCsvModel.fromResponse(dynamic response) {
    if (response is String) {
      return SampleCsvModel(content: response);
    }

    return const SampleCsvModel();
  }

  String toCsv() {
    return content;
  }

  bool get isNotEmpty => content.trim().isNotEmpty;

  int get lineCount {
    if (content.trim().isEmpty) {
      return 0;
    }

    return content.trim().split('\n').length;
  }
}
