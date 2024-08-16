import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WeMotionVideoPlayer extends StatefulWidget {
  const WeMotionVideoPlayer(
      {super.key, required this.uri, required this.onTap, this.shouldPlay});

  final String uri;
  final void Function()? onTap;
  final bool? shouldPlay;

  @override
  State<WeMotionVideoPlayer> createState() => _WeMotionVideoPlayerState();
}

class _WeMotionVideoPlayerState extends State<WeMotionVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.uri!))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shouldPlay != null) _controller.play();
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: VideoPlayer(_controller),
          ),
        ),
        if (widget.shouldPlay != null)
          InkWell(
            onTap: widget.onTap,
            child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                )),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
