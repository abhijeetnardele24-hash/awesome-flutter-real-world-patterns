import 'package:flutter/material.dart';

import 'application/upload_controller.dart';
import 'data/fake_upload_service.dart';

void main() {
  runApp(
    UploadFlowApp(
      controller: UploadController(const FakeUploadService()),
    ),
  );
}

class UploadFlowApp extends StatelessWidget {
  const UploadFlowApp({
    super.key,
    required this.controller,
  });

  final UploadController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'File Upload Flow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
        ),
        useMaterial3: true,
      ),
      home: UploadFlowScreen(controller: controller),
    );
  }
}

class UploadFlowScreen extends StatefulWidget {
  const UploadFlowScreen({
    super.key,
    required this.controller,
  });

  final UploadController controller;

  @override
  State<UploadFlowScreen> createState() => _UploadFlowScreenState();
}

class _UploadFlowScreenState extends State<UploadFlowScreen> {
  final _fileNameController = TextEditingController(text: 'resume.pdf');

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final current = widget.controller.currentUpload;

        return Scaffold(
          appBar: AppBar(
            title: const Text('File Upload Flow'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload a file',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Type a file name and run the fake upload flow. Use a name like "avatar-fail.png" to simulate a failure.',
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _fileNameController,
                        decoration: const InputDecoration(
                          labelText: 'File name',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          FilledButton(
                            onPressed: widget.controller.isUploading
                                ? null
                                : () => widget.controller.startUpload(
                                      _fileNameController.text,
                                    ),
                            child: const Text('Start upload'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: widget.controller.isUploading
                                ? null
                                : widget.controller.retryLastFailedUpload,
                            child: const Text('Retry failed upload'),
                          ),
                        ],
                      ),
                      if (current != null) ...[
                        const SizedBox(height: 20),
                        Text(
                          'Current upload: ${current.fileName}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(value: current.progress),
                        const SizedBox(height: 10),
                        Text(_buildStatusText(current)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Upload history',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (widget.controller.history.isEmpty)
                const Text('No uploads yet.')
              else
                ...widget.controller.history.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      child: ListTile(
                        title: Text(item.fileName),
                        subtitle: Text(item.message ?? _buildStatusText(item)),
                        trailing: _StatusBadge(status: item.status),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _buildStatusText(UploadRecord record) {
    switch (record.status) {
      case UploadStatus.idle:
        return 'Waiting to upload';
      case UploadStatus.uploading:
        return 'Uploading ${(record.progress * 100).round()}%';
      case UploadStatus.success:
        return 'Upload complete';
      case UploadStatus.failure:
        return record.message ?? 'Upload failed';
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.status,
  });

  final UploadStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final (label, color) = switch (status) {
      UploadStatus.idle => ('Idle', colorScheme.secondary),
      UploadStatus.uploading => ('Uploading', colorScheme.primary),
      UploadStatus.success => ('Success', Colors.green),
      UploadStatus.failure => ('Failed', colorScheme.error),
    };

    return Chip(
      label: Text(label),
      backgroundColor: color.withAlpha(24),
      side: BorderSide(color: color.withAlpha(60)),
    );
  }
}
