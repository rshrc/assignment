import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:trell_video_player/picker/selection.dart';
import 'package:trell_video_player/widgets/bookmark_widget.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  MediaPickerSelection selection;
  int index;

  VideoPlayer({this.selection, this.index});

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;
  bool _loading = true;

  getVideo() async {
    await widget.selection.selectedMedias[widget.index].getFile().then((file) {
      _videoPlayerController1 = VideoPlayerController.file(file);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        aspectRatio: (MediaQuery.of(context).size.width)/MediaQuery.of(context).size.height,
        autoPlay: true,
        looping: false,
        allowFullScreen: false,
      );
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    getVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Stack(
            children: [
              Chewie(
                controller: _chewieController,
              ),
              BookmarkWidget(index: widget.index, stored: false),
            ],
          ),
        );
  }
}
