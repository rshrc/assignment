import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';

import 'labels.dart';
import 'selection.dart';
import 'validate.dart';
import 'selectable.dart';
import 'thumbnail.dart';

class MediasPage extends StatefulWidget {
  final MediaCollection collection;
  MediasPage({
    @required this.collection,
  });

  @override
  _MediaImagesPageState createState() => _MediaImagesPageState();
}

class _MediaImagesPageState extends State<MediasPage> {
  @override
  Widget build(BuildContext context) {
    final selection = MediaPickerSelection.of(context);
    final labels = MediaPickerLabels.of(context);
    return DefaultTabController(
      length: selection.mediaTypes.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.collection.name),
          actions: <Widget>[
            PickerValidateButton(
              onValidate: (selection) => Navigator.pop(context, selection),
            ),
          ],
          bottom: selection.mediaTypes.length > 1
              ? TabBar(
                  tabs: selection.mediaTypes
                      .map(
                        (x) => Tab(
                          text: x == MediaType.video
                              ? labels.videos
                              : labels.images,
                        ),
                      )
                      .toList(),
                )
              : null,
        ),
        body: TabBarView(
          children: selection.mediaTypes
              .map(
                (x) => MediaGrid(
                  key: Key(x.toString()),
                  collection: widget.collection,
                  mediaType: x,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class MediaGrid extends StatefulWidget {
  final MediaCollection collection;
  final MediaType mediaType;
  MediaGrid({
    Key key,
    @required this.mediaType,
    @required this.collection,
  }) : super(key: key);

  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid>
    with AutomaticKeepAliveClientMixin {
  List<MediaPage> pages = [];
  bool isLoading = false;

  bool get canLoadMore =>
      !isLoading && pages.isNotEmpty && (!pages.last.isLast);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAsync();
    });
    super.initState();
  }

  Future<void> initAsync() async {
    setState(() {
      isLoading = true;
    });
    try {
      pages.add(
        await widget.collection.getMedias(
          mediaType: widget.mediaType,
        ),
      );
      setState(() {});
    } catch (e) {
      print("Failed : $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadMore() async {
    setState(() {
      isLoading = true;
    });
    try {
      final nextPage = await pages.last.nextPage();
      pages.add(nextPage);
    } catch (e) {} finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mediaQuery = MediaQuery.of(context);
    final allMedias = pages.expand((x) => x.items);
    final crossAxisCount = (mediaQuery.size.width / 128).ceil();
    final selection = MediaPickerSelection.of(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (canLoadMore &&
            scrollInfo.metrics.pixels + mediaQuery.size.height >=
                scrollInfo.metrics.maxScrollExtent) {
          loadMore();
        }
        return false;
      },
      child: GridView(
        children: <Widget>[
          ...allMedias.map<Widget>(
            (x) => AnimatedBuilder(
              key: Key(x.id),
              animation: selection,
              builder: (context, _) => InkWell(
                onTap: () => selection.toggle(x),
                child: Selectable(
                  isSelected: selection.contains(x),
                  child: MediaThumbnailImage(
                    media: x,
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Center(
              key: Key("more_loader"),
              child: CircularProgressIndicator(),
            ),
        ],
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1.0,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
