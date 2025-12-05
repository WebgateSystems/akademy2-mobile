import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePreviewDialog extends StatefulWidget {
  const YoutubePreviewDialog({required this.videoId});

  final String videoId;

  @override
  State<YoutubePreviewDialog> createState() => _YoutubePreviewDialogState();
}

class _YoutubePreviewDialogState extends State<YoutubePreviewDialog> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHD: true,
        enableCaption: true,
        useHybridComposition: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        body: Center(
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
      ),
    );
  }
}
