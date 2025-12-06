import 'dart:io';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/features/modules/models/subtitle_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePreviewDialog extends StatefulWidget {
  const YoutubePreviewDialog({
    required this.videoId,
    this.subtitlesUrl,
  });

  final String videoId;
  final String? subtitlesUrl;

  @override
  State<YoutubePreviewDialog> createState() => _YoutubePreviewDialogState();
}

class _YoutubePreviewDialogState extends State<YoutubePreviewDialog> {
  late final YoutubePlayerController _controller;
  List<SubtitleEntry> _subtitles = [];
  String _currentSubtitle = '';

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHD: true,
        // Disable YouTube captions if we have custom subtitles
        enableCaption: widget.subtitlesUrl == null,
        useHybridComposition: true,
      ),
    );

    // Load custom subtitles if provided
    if (widget.subtitlesUrl != null && widget.subtitlesUrl!.isNotEmpty) {
      _loadSubtitles(widget.subtitlesUrl!);
    }

    _controller.addListener(_onVideoProgress);
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
        // Local file
        final file = url.startsWith('file://') && uri != null
            ? File.fromUri(uri)
            : File(url);
        if (await file.exists()) {
          content = await file.readAsString();
        } else {
          return;
        }
      }

      // Parse subtitles (supports both SRT and VTT)
      _subtitles = _parseSubtitles(content);
      debugPrint('YouTube: Loaded ${_subtitles.length} subtitle entries');
    } catch (e) {
      debugPrint('Error loading subtitles for YouTube: $e');
    }
  }

  List<SubtitleEntry> _parseSubtitles(String content) {
    final entries = <SubtitleEntry>[];

    // Remove BOM if present
    content = content.replaceAll('\uFEFF', '');

    // Split into blocks (works for both SRT and VTT)
    final blocks = content.split(RegExp(r'\n\s*\n'));

    for (final block in blocks) {
      final lines = block.trim().split('\n');
      if (lines.length < 2) continue;

      // Find timestamp line
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

      // Get text (all lines after timestamp)
      final textLines = lines.sublist(timestampIndex + 1);
      final text = textLines
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .join('\n')
          // Remove VTT styling tags
          .replaceAll(RegExp(r'<[^>]+>'), '');

      if (text.isNotEmpty) {
        entries.add(SubtitleEntry(start: start, end: end, text: text));
      }
    }

    return entries;
  }

  Duration? _parseTimestamp(String timestamp) {
    try {
      // Handle both SRT (00:00:00,000) and VTT (00:00:00.000) formats
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
        // MM:SS.mmm format
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
    if (_subtitles.isEmpty) return;

    final position = _controller.value.position;
    String newSubtitle = '';

    for (final entry in _subtitles) {
      if (position >= entry.start && position <= entry.end) {
        newSubtitle = entry.text;
        break;
      }
    }

    if (newSubtitle != _currentSubtitle && mounted) {
      setState(() => _currentSubtitle = newSubtitle);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoProgress);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // YouTube Player
          Center(
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.redAccent,
              ),
              builder: (context, player) {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: player,
                );
              },
            ),
          ),

          // Custom subtitles overlay
          if (_currentSubtitle.isNotEmpty)
            Positioned(
              bottom: 80.h,
              left: 16.w,
              right: 16.w,
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

          // Close button - separate widget, on top of everything
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
