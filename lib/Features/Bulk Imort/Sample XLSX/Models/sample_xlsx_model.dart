class SampleXlsxModel {
  const SampleXlsxModel({this.bytes = const <int>[]});

  final List<int> bytes;

  factory SampleXlsxModel.fromResponse(List<int>? response) {
    if (response == null || response.isEmpty) {
      return const SampleXlsxModel();
    }

    return SampleXlsxModel(bytes: List<int>.from(response));
  }

  bool get isNotEmpty => bytes.isNotEmpty;

  int get sizeInBytes => bytes.length;

  double get sizeInKb => sizeInBytes / 1024;

  double get sizeInMb => sizeInKb / 1024;
}
