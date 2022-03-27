import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'getstartedbuton.dart';


class getStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        //we will give media query height
        //double.infinity make it big as my parent allows
        //while MediaQuery make it as big as the screen

        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          //even space distribution
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Never Loose Track of your Medication",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                child: Lottie.network('https://assets5.lottiefiles.com/packages/lf20_pk5mpw6j.json'),
              ),
            ),
            Column(
              children: <Widget>[
                myGetStartedButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}