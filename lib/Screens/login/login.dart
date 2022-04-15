import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medi_health1/Screens/login/logingesturedetector.dart';
import 'package:medi_health1/mywidget.dart';
import 'package:http/http.dart' as http;

import '../../sharedprefferences.dart';
import '../Dashboard/dashboard.dart';

class firstLoginPage extends StatefulWidget {
  const firstLoginPage({Key? key}) : super(key: key);

  @override
  State<firstLoginPage> createState() => _firstLoginPageState();
}

class _firstLoginPageState extends State<firstLoginPage> {
  String loggedinUser = " ";
  bool isChecked = false;

  bool isSignUpScreen = false;
  bool isRememberMe = false;
  final Preferences _prefs = Preferences();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late ScaffoldMessengerState scaffoldMessenger;

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/Login.jpg"), fit: BoxFit.fill),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 220,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/hospitalicon.png")),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/hospitalicon2.png")),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin: EdgeInsets.only(top: 0),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFF94C3DD),
                                blurRadius: 20.0,
                                offset: Offset(0, 10)),
                          ]),
                      child: Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.black))),
                              child: TextField(
                                keyboardType: TextInputType.name,
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              )),
                          Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                keyboardType: TextInputType.name,
                                obscureText: true,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: loginFunction,
                        //print(isChecked);
                      //loginFunction,
                      //defining the shape
                      color: Color(0xFF94C3DD),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 120,
                        ),
                      ], //<Widget>[]
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    myForgotPasswordGestureDetector(),

                    SizedBox(
                      height: 15,
                    ),

                    mySignUpGestureDetector(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  checkBoxValue(){
    if(isChecked == true){
      _prefs.getStringValuesSF("email").then((email) => {
        setState(() => {
          emailController.text = email!,
        })
      });
    }
  }


  void loginFunction() {
    if (emailController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Provide Email"),
      );
      return;
    } else if (passwordController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Provide Password"),
      );
      return;
    } else {
      //call sigin function
      print(emailController.text);
      print(passwordController.text);
      checkBoxValue();
      signIn(emailController.text, passwordController.text);
    }
  }

  signIn(String email, String password) async {
    DialogBuilder(context).showLoadingIndicator(

        "Please wait as we authenticate you", "Authentication");
    Map data = {'email': email, 'password': password};
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
        var firstname = jsonResponse['fname'];
        var emailAddress = jsonResponse['email'];
        print(firstname);
        print(emailAddress);
        if (isRegistered == 1) {
          //correct password
          //move to dashboard
          _prefs.addStringToSF("firstname", firstname);
          _prefs.addStringToSF("emailAddress", emailAddress);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          //wrongpassword use SnackBar to Show
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
