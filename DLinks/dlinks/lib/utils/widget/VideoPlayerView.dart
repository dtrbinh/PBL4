import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'ControlsOverlay.dart';

class VideoPlayerView extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerView(this.videoUrl, {Key? key}) : super(key: key);

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController videoController;

  @override
  void initState() {
    videoController = VideoPlayerController.network(widget.videoUrl);
    videoController.initialize().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: videoController.value.aspectRatio,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              VideoPlayer(videoController),
              ClosedCaption(text: videoController.value.caption.text),
              ControlsOverlay(controller: videoController),
              VideoProgressIndicator(videoController, allowScrubbing: true),
            ],
          )),
    );
  }
}
