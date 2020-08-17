import 'package:flutter/material.dart';
import 'package:trell_video_player/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return MyApp();
            })));
    return Scaffold(
      body: Center(
        child: CircleAvatar(
          radius: 32,
          backgroundImage: AssetImage('assets/images/trell_logo.jpeg'),
        ),
      ),
    );
  }
}
