import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopbuzz_ecommerce/pages/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen())));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/shopbuzz-logo.png', height: 90.0,),
            SizedBox(height: 30.0,),

            SpinKitRipple(color: Colors.green, size: 70,)
          ],

      ),
    );
  }
}