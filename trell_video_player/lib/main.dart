import 'package:flutter/material.dart';
import 'package:trell_video_player/picker/picker.dart';
import 'package:trell_video_player/picker/selection.dart';
import 'package:trell_video_player/splash_screen.dart';
import 'package:trell_video_player/views/video_list_view.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(primaryColor: Colors.red),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MediaPickerSelection selection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text("Trell Video Player"),
        centerTitle: true,
      ),
      body: VideoListView(
        selection: selection,
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          tooltip: "Tap to Load Videos",
          backgroundColor: Colors.red,
          onPressed: () async {
            final result = await MediaPicker.show(context);
            if (result != null) {
              setState(() => selection = result);
            }
          },
          child: Icon(Icons.video_library),
        ),
      ),
    );
  }
}
