class FakeUploadService {
  const FakeUploadService();

  Stream<double> upload(String fileName) async* {
    if (fileName.trim().isEmpty) {
      throw Exception('Choose a file before starting the upload.');
    }

    final normalized = fileName.toLowerCase();

    for (var step = 1; step <= 5; step++) {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      yield step / 5;
    }

    if (normalized.contains('fail')) {
      throw Exception('The upload failed. Retry after checking the network.');
    }
  }
}
