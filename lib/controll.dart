import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class PlayingControls extends StatelessWidget {
  final bool isPlaying;
  final LoopMode? loopMode;
  final bool isPlaylist;
  final Function()? onPrevious;
  final Function() onPlay;
  final Function()? onNext;
  final Function()? onRepeat;

  PlayingControls(
      {required this.isPlaying,
      this.isPlaylist = false,
      this.loopMode,
      this.onPrevious,
      required this.onPlay,
      this.onNext,
      this.onRepeat});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: isPlaylist ? onPrevious : null,
          icon: Icon(
            Icons.skip_previous,
            size: 32,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: onPlay,
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 32,
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: Icon(Icons.skip_next),
          color: Colors.white,
          iconSize: 32,
        ),
        // IconButton(
        //   onPressed: onRepeat,
        //   icon: Icon(
        //     Icons.repeat,
        //     color: Colors.white,
        //     size: 32,
        //   ),
        // )
      ],
    );
  }
}
