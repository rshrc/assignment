import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkWidget extends StatefulWidget {
  int index;
  bool stored;

  BookmarkWidget({this.index, this.stored});

  @override
  _BookmarkWidgetState createState() => _BookmarkWidgetState();
}

class _BookmarkWidgetState extends State<BookmarkWidget> {
  bool bookmarked;

  @override
  void initState() {
    bookmarked = widget.stored ?? false;
    print("Line 150 : $bookmarked");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () async {
            // bookmark
            SharedPreferences prefs = await SharedPreferences.getInstance();

            print("Line 114: $bookmarked");

            if (bookmarked) {
              await prefs.setBool('${widget.index}', false).then((value) {
                setState(() {
                  bookmarked = false;
                });
              });
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(content: Text("Unbooked Video ${widget.index}")));
            } else {
              await prefs.setBool('${widget.index}', true).then((value) {
                setState(() {
                  bookmarked = true;
                });
              });
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text("Bookmarked Video ${widget.index}")));
            }
          },
          icon: bookmarked
              ? Icon(Icons.bookmark, color: Colors.white)
              : Icon(
                  Icons.bookmark_border,
                  color: Colors.white,
                ),
        )
      ],
    );
  }
}
