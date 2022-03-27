import 'package:flutter/material.dart';

import '../login/login.dart';

class mybutton extends StatelessWidget {
  const mybutton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      height: 60,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => firstLoginPage()));
      },
      //defining the shape
      color: Color(0xFF94C3DD),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        "Reset Password",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18),
      ),
    );
  }
}
