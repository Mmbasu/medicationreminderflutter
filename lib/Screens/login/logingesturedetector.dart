import 'package:flutter/material.dart';

import '../signup/signup.dart';
import '../resetpassword/resetpassword.dart';


class myForgotPasswordGestureDetector extends StatelessWidget {
  const myForgotPasswordGestureDetector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Text(
          "Forgot Password",
          style:
              TextStyle(color: Color(0xFF94C3DD), fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ResetPassword()));
        });
  }
}

class mySignUpGestureDetector extends StatelessWidget {
  const mySignUpGestureDetector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        "Don't have an account? Signup",
        style: TextStyle(color: Color(0xFF94C3DD), fontWeight: FontWeight.bold),
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Signup()));
      },
    );
  }
}
