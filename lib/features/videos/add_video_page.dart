import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/db/entities/subject_entity.dart';
import '../../core/db/isar_service.dart';
import 'video_service.dart';

class AddVideoPage extends StatefulWidget {
  const AddVideoPage({super.key});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  PlatformFile? _file;
  VideoPlayerController? _controller;
  String? _subjectId;
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _saving = false;
  List<SubjectEntity> _subjects = [];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSubjects() async {
    final isar = IsarService();
    final subjects = await isar.getSubjects();
    setState(() {
      _subjects = subjects;
      if (_subjects.isNotEmpty) _subjectId = _subjects.first.id;
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.isNotEmpty) {
      _file = result.files.first;
      _controller?.dispose();
      final file = File(_file!.path!);
      _controller = VideoPlayerController.file(file);
      await _controller!.initialize();
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (_file == null || _subjectId == null || _titleCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      await VideoService().addVideo(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        subjectId: _subjectId!,
        filePath: _file!.path ?? '',
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to upload: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit =
        _file != null && _subjectId != null && _titleCtrl.text.trim().isNotEmpty;
    return Scaffold(
      appBar: AppBar(title: const Text('Add video')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                ),
                child: _controller != null && _controller!.value.isInitialized
                    ? Stack(
                        children: [
                          Center(
                            child: AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: VideoPlayer(_controller!),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: IconButton(
                              icon: Icon(_controller!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow),
                              onPressed: () {
                                setState(() {
                                  if (_controller!.value.isPlaying) {
                                    _controller!.pause();
                                  } else {
                                    _controller!.play();
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    : const Center(child: Text('Tap to choose a video')),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _subjectId,
              decoration: const InputDecoration(
                labelText: 'Choose the topic',
                border: OutlineInputBorder(),
              ),
              items: _subjects
                  .map((s) => DropdownMenuItem(value: s.id, child: Text(s.title)))
                  .toList(),
              onChanged: (v) => setState(() => _subjectId = v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSubmit && !_saving ? _submit : null,
                child: _saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
