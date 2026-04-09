import 'package:flutter/foundation.dart';

import '../data/fake_upload_service.dart';

enum UploadStatus {
  idle,
  uploading,
  success,
  failure,
}

class UploadRecord {
  const UploadRecord({
    required this.fileName,
    required this.status,
    required this.progress,
    this.message,
  });

  final String fileName;
  final UploadStatus status;
  final double progress;
  final String? message;

  UploadRecord copyWith({
    UploadStatus? status,
    double? progress,
    String? message,
  }) {
    return UploadRecord(
      fileName: fileName,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      message: message ?? this.message,
    );
  }
}

class UploadController extends ChangeNotifier {
  UploadController(this._service);

  final FakeUploadService _service;

  UploadRecord? _currentUpload;
  final List<UploadRecord> _history = [];

  UploadRecord? get currentUpload => _currentUpload;
  List<UploadRecord> get history => List.unmodifiable(_history.reversed);

  bool get isUploading => _currentUpload?.status == UploadStatus.uploading;

  Future<void> startUpload(String fileName) async {
    if (isUploading) {
      return;
    }

    _currentUpload = UploadRecord(
      fileName: fileName,
      status: UploadStatus.uploading,
      progress: 0,
    );
    notifyListeners();

    try {
      await for (final progress in _service.upload(fileName)) {
        _currentUpload = _currentUpload?.copyWith(progress: progress);
        notifyListeners();
      }

      final completed = _currentUpload?.copyWith(
        status: UploadStatus.success,
        progress: 1,
        message: 'Upload complete',
      );

      if (completed != null) {
        _history.add(completed);
        _currentUpload = completed;
      }

      notifyListeners();
    } catch (error) {
      final failed = _currentUpload?.copyWith(
        status: UploadStatus.failure,
        message: error.toString(),
      );

      if (failed != null) {
        _history.add(failed);
        _currentUpload = failed;
      }

      notifyListeners();
    }
  }

  Future<void> retryLastFailedUpload() async {
    final failed = _history.lastWhere(
      (item) => item.status == UploadStatus.failure,
      orElse: () => const UploadRecord(
        fileName: '',
        status: UploadStatus.idle,
        progress: 0,
      ),
    );

    if (failed.fileName.isEmpty) {
      return;
    }

    await startUpload(failed.fileName);
  }
}
