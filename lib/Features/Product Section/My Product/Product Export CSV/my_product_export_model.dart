class MyProductExportModel {
  const MyProductExportModel({this.csvContent = ''});

  /// Complete CSV response returned by API.
  final String csvContent;

  factory MyProductExportModel.fromResponse(String? response) {
    if (response == null || response.trim().isEmpty) {
      return const MyProductExportModel();
    }

    return MyProductExportModel(csvContent: response);
  }

  bool get isEmpty => csvContent.trim().isEmpty;

  bool get isNotEmpty => csvContent.trim().isNotEmpty;

  int get byteLength => csvContent.codeUnits.length;
}
