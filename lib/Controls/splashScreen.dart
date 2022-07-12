import 'dart:async';

import 'package:flutter/material.dart';
import 'package:salesman/CommonClass/Key.dart';
import 'package:salesman/Controls/HomeScreen/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences _pref;

  String logging;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logging = null;
    getSharedFun();
  }
  void getSharedFun() async {
    timeOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/Splash.png",
            //fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
  void timeOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    logging = prefs.getString(MyKey.loginStatus);
    Timer(Duration(seconds: 3), () async {
      print("printed after 3 seconds vvx");
      if(logging == null)
        {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
     else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }
}
