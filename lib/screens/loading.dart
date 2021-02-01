import 'package:MG/screens/loginPage.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new LoginPage()));
    });

    return Scaffold(
      body: Center(
        child: Image(
          image: AssetImage("assets/jjmlogo.png"),
          width: 500.0,
          height: 200.0,
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
