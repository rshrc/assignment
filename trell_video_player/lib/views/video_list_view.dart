import 'package:flutter/material.dart';
import 'package:trell_video_player/picker/selection.dart';
import 'package:trell_video_player/widgets/video_player.dart';

class VideoListView extends StatelessWidget {
  final MediaPickerSelection selection;

  const VideoListView({
    @required this.selection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: selection == null || selection.selectedMedias.isEmpty
          ? Center(child: Text("No Videos Selected"))
          : ListView.builder(
          itemCount: selection.selectedMedias.length,
          itemBuilder: (context, index) {
            return VideoPlayer(
              selection: selection,
              index: index,
            );
          }),
    );
  }
}