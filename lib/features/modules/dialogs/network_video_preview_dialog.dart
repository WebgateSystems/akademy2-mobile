import 'dart:io';

import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NetworkVideoPreviewDialog extends StatefulWidget {
  const NetworkVideoPreviewDialog({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<NetworkVideoPreviewDialog> createState() =>
      _NetworkVideoPreviewDialogState();
}

class _NetworkVideoPreviewDialogState extends State<NetworkVideoPreviewDialog> {
  VideoPlayerController? _controller;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    VideoPlayerController? controller;
    try {
      final uri = Uri.tryParse(widget.videoUrl);
      final isNetwork =
          uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
      controller = isNetwork
          ? VideoPlayerController.networkUrl(uri)
          : VideoPlayerController.file(
              widget.videoUrl.startsWith('file://') && uri != null
                  ? File.fromUri(uri)
                  : File(widget.videoUrl),
            );
      await controller.initialize();
      controller.play();
      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _loading = false;
      });
    } catch (_) {
      controller?.dispose();
      if (!mounted) return;
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        body: Center(
          child: _loading
              ? const CircularProgressWidget()
              : _error || _controller == null
                  ? const Icon(Icons.error, color: Colors.white)
                  : AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
        ),
      ),
    );
  }
}
