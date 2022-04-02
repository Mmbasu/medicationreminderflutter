import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medi_health1/inputfield.dart';
import 'Constants.dart';
import 'Screens/settings/settings.dart';
import 'mywidget.dart';
import 'package:http/http.dart'as http;




class changePassword extends StatefulWidget {
  const changePassword({Key? key}) : super(key: key);

  @override
  State<changePassword> createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {

  TextEditingController emailController = TextEditingController();
  TextEditingController previouspasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmnewpasswordController = TextEditingController();

  var loggedinUser = " ";


  late ScaffoldMessengerState scaffoldMessenger;


  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Image.network(
              "https://medihealth2.000webhostapp.com/userprofilepictures/griffin.jpg"),

          // onPressed: () {
          //   print('Click leading');
          // },
          //),
        ),
        automaticallyImplyLeading: false,
        title: Text("Hello " + loggedinUser),
        titleTextStyle: TextStyle(color: Colors.black,
            //fontWeight: FontWeight.w600,
            fontSize: 20),
        backgroundColor: Color(0xFF94C3DD),


        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MySettings()));
                });
              },
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: 35,
              )
          ),
        ],

      ),


      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Change Password",
                style: HeadingStyle,
              ),
              MyInputField(title: "Email",
                hint: "Enter your Email",
                inputfieldcontroller: emailController,),
              MyInputField(title: "Previous Password",
                hint: "Enter your previous password",
                inputfieldcontroller: previouspasswordController,),
              MyInputField(title: "New Password",
                hint: "Enter your New password",
                inputfieldcontroller: newpasswordController,),
              MyInputField(title: "Confirm New Password",
                hint: "Confirm your New Password",
                inputfieldcontroller: confirmnewpasswordController,),

              SizedBox(height: 18,),

              FloatingActionButton.extended(
                onPressed: changePasswordFunction,
                backgroundColor: Color(0xFF94C3DD),
                label: Text("Change Password"),
              ),

            ],
          ),
        ),

      ),
    );
  }

  void changePasswordFunction() {
    if (emailController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Provide Email"),
      );
      return;
    } else if (previouspasswordController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Provide Previous Password"),
      );
      return;
    } else if (newpasswordController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Provide new Password"),
      );
      return;
    }else if (confirmnewpasswordController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Please Confirm Password"),
      );
      return;
    } else if (newpasswordController.text != confirmnewpasswordController.text) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Passwords don't match!!"),
      );
      return;
    }
    else {
      //signIn(emailController.text, passwordController.text);
    }
  }

  changePassword(String email, String password, String newPassword) async {
    DialogBuilder(context).showLoadingIndicator(
        "Please wait as we authenticate you", "Authentication");
    Map data = {'email': email, 'password': password, 'newPassword':newPassword};
    var jsonResponse;
    var response = await http.post(
        Uri.parse("https://medihealth2.000webhostapp.com/login.php"),
        body: data);
    //use shared preferences to store username
    //in the shared preferences we can store the name
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          DialogBuilder(context).hideOpenDialog();
        });
        int isRegistered = jsonResponse['code'];
        if (isRegistered == 1) {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          scaffoldMessenger.showSnackBar(
            mySnackBar("Wrong Credentials"),
          );
        }
      }
    } else {
      setState(() {
        DialogBuilder(context).hideOpenDialog();
      });
    }
  }
}
