import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:snapping_page_scroll/snapping_page_scroll.dart';
import 'package:trell_video_player/picker/selection.dart';
import 'package:trell_video_player/widgets/video_player.dart';

class VideoListView extends StatelessWidget {
  final MediaPickerSelection selection;

  const VideoListView({
    @required this.selection,
  });

  List<Widget> _buildSnapChildren(MediaPickerSelection selection, context) {
    List<Widget> videos = [];

    for (int i = 0; i < selection.selectedMedias.length; i++) {
      videos.add(Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: VideoPlayer(
            selection: selection,
            index: i,
          )));
    }

    return videos;
  }

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
            : SnappingPageScroll(
                scrollDirection: Axis.vertical,
                children: _buildSnapChildren(selection, context),
              ));
  }
}
