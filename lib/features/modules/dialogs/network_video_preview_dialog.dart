import 'dart:io';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:academy_2_app/features/modules/models/subtitle_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class NetworkVideoPreviewDialog extends StatefulWidget {
  const NetworkVideoPreviewDialog({
    super.key,
    required this.videoUrl,
    this.subtitlesUrl,
  });

  final String videoUrl;
  final String? subtitlesUrl;

  @override
  State<NetworkVideoPreviewDialog> createState() =>
      _NetworkVideoPreviewDialogState();
}

class _NetworkVideoPreviewDialogState extends State<NetworkVideoPreviewDialog> {
  VideoPlayerController? _controller;
  bool _loading = true;
  bool _error = false;
  List<SubtitleEntry> _subtitles = [];
  String _currentSubtitle = '';
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    VideoPlayerController? controller;
    try {
      debugPrint('NetworkVideoPreviewDialog: videoUrl = ${widget.videoUrl}');

      final uri = Uri.tryParse(widget.videoUrl);
      final isNetwork =
          uri != null && (uri.scheme == 'http' || uri.scheme == 'https');

      debugPrint(
          'NetworkVideoPreviewDialog: isNetwork = $isNetwork, uri = $uri');

      if (isNetwork) {
        controller = VideoPlayerController.networkUrl(uri);
      } else {
        final file = widget.videoUrl.startsWith('file://') && uri != null
            ? File.fromUri(uri)
            : File(widget.videoUrl);

        debugPrint('NetworkVideoPreviewDialog: Local file path = ${file.path}');
        debugPrint(
            'NetworkVideoPreviewDialog: File exists = ${file.existsSync()}');

        if (!file.existsSync()) {
          throw Exception('Local video file not found: ${file.path}');
        }

        controller = VideoPlayerController.file(file);
      }

      await controller.initialize();
      debugPrint('NetworkVideoPreviewDialog: Video initialized successfully');

      if (widget.subtitlesUrl != null && widget.subtitlesUrl!.isNotEmpty) {
        await _loadSubtitles(widget.subtitlesUrl!);
      }

      controller.addListener(_onVideoProgress);
      controller.play();

      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _loading = false;
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showControls = false);
      });
    } catch (e, st) {
      debugPrint('Video init error: $e');
      debugPrint('Stack trace: $st');
      controller?.dispose();
      if (!mounted) return;
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  Future<void> _loadSubtitles(String url) async {
    try {
      final uri = Uri.tryParse(url);
      String content;

      if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
        final response = await http.get(uri);
        if (response.statusCode == 200) {
          content = response.body;
        } else {
          return;
        }
      } else {
        final file = url.startsWith('file://') && uri != null
            ? File.fromUri(uri)
            : File(url);
        if (await file.exists()) {
          content = await file.readAsString();
        } else {
          return;
        }
      }

      _subtitles = _parseSubtitles(content);
      debugPrint('Loaded ${_subtitles.length} subtitle entries');
    } catch (e) {
      debugPrint('Error loading subtitles: $e');
    }
  }

  List<SubtitleEntry> _parseSubtitles(String content) {
    final entries = <SubtitleEntry>[];

    content = content.replaceAll('\uFEFF', '');

    final blocks = content.split(RegExp(r'\n\s*\n'));
    for (final block in blocks) {
      final lines = block.trim().split('\n');
      if (lines.length < 2) continue;

      int timestampIndex = 0;
      for (int i = 0; i < lines.length; i++) {
        if (lines[i].contains('-->')) {
          timestampIndex = i;
          break;
        }
      }

      if (timestampIndex >= lines.length) continue;

      final timestampLine = lines[timestampIndex];
      final timestamps = timestampLine.split('-->');
      if (timestamps.length != 2) continue;

      final start = _parseTimestamp(timestamps[0].trim());
      final end = _parseTimestamp(timestamps[1].trim().split(' ').first);

      if (start == null || end == null) continue;

      final textLines = lines.sublist(timestampIndex + 1);
      final text = textLines
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .join('\n')
          .replaceAll(RegExp(r'<[^>]+>'), '');

      if (text.isNotEmpty) {
        entries.add(SubtitleEntry(start: start, end: end, text: text));
      }
    }

    return entries;
  }

  Duration? _parseTimestamp(String timestamp) {
    try {
      timestamp = timestamp.replaceAll(',', '.');

      final parts = timestamp.split(':');
      if (parts.length == 3) {
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        final secondsParts = parts[2].split('.');
        final seconds = int.parse(secondsParts[0]);
        final milliseconds = secondsParts.length > 1
            ? int.parse(secondsParts[1].padRight(3, '0').substring(0, 3))
            : 0;
        return Duration(
          hours: hours,
          minutes: minutes,
          seconds: seconds,
          milliseconds: milliseconds,
        );
      } else if (parts.length == 2) {
        final minutes = int.parse(parts[0]);
        final secondsParts = parts[1].split('.');
        final seconds = int.parse(secondsParts[0]);
        final milliseconds = secondsParts.length > 1
            ? int.parse(secondsParts[1].padRight(3, '0').substring(0, 3))
            : 0;
        return Duration(
          minutes: minutes,
          seconds: seconds,
          milliseconds: milliseconds,
        );
      }
    } catch (e) {
      debugPrint('Error parsing timestamp "$timestamp": $e');
    }
    return null;
  }

  void _onVideoProgress() {
    if (_controller == null || _subtitles.isEmpty) return;

    final position = _controller!.value.position;
    String newSubtitle = '';

    for (final entry in _subtitles) {
      if (position >= entry.start && position <= entry.end) {
        newSubtitle = entry.text;
        break;
      }
    }

    if (newSubtitle != _currentSubtitle) {
      setState(() => _currentSubtitle = newSubtitle);
    }
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoProgress);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleControls,
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  Center(
                    child: _loading
                        ? const CircularProgressWidget()
                        : _error || _controller == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error,
                                      color: Colors.white, size: 48),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Помилка завантаження відео',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14.sp),
                                  ),
                                ],
                              )
                            : AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!),
                              ),
                  ),

                  if (_currentSubtitle.isNotEmpty)
                    Positioned(
                      bottom: 80.h,
                      left: 20.w,
                      right: 20.w,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _currentSubtitle,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.h5(context).copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                  if (_showControls &&
                      !_loading &&
                      !_error &&
                      _controller != null) ...[
                    Center(
                      child: GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _controller!.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 48.w,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 20.h,
                      left: 16.w,
                      right: 16.w,
                      child: VideoProgressIndicator(
                        _controller!,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.white,
                          bufferedColor: Colors.white30,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 24.h,
            right: 8.w,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(24.w),
                child: Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 24.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
