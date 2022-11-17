import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ControlsOverlay extends StatefulWidget {
  static const List<Duration> exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  const ControlsOverlay({Key? key, required this.controller}) : super(key: key);

  @override
  State<ControlsOverlay> createState() => ControlsOverlayState();
}

class ControlsOverlayState extends State<ControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: widget.controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            widget.controller.value.isPlaying
                ? widget.controller.pause()
                : widget.controller.play();
            setState(() {});
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Visibility(
            visible: !widget.controller.value.isPlaying,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white.withOpacity(0.5),
              ),
              child: PopupMenuButton<Duration>(
                initialValue: widget.controller.value.captionOffset,
                tooltip: 'Caption Offset',
                onSelected: (Duration delay) {
                  widget.controller.setCaptionOffset(delay);
                  setState(() {});
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuItem<Duration>>[
                    for (final Duration offsetDuration
                        in ControlsOverlay.exampleCaptionOffsets)
                      PopupMenuItem<Duration>(
                        value: offsetDuration,
                        child: Text('${offsetDuration.inMilliseconds}ms'),
                      )
                  ];
                },
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                      '${widget.controller.value.captionOffset.inMilliseconds}ms'),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Visibility(
            visible: !widget.controller.value.isPlaying,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white.withOpacity(0.5),
              ),
              child: PopupMenuButton<double>(
                initialValue: widget.controller.value.playbackSpeed,
                tooltip: 'Playback speed',
                onSelected: (double speed) {
                  widget.controller.setPlaybackSpeed(speed);
                  setState(() {});
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuItem<double>>[
                    for (final double speed
                        in ControlsOverlay.examplePlaybackRates)
                      PopupMenuItem<double>(
                        value: speed,
                        child: Text('${speed}x'),
                      )
                  ];
                },
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text('${widget.controller.value.playbackSpeed}x'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
