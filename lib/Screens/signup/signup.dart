import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../mywidget.dart';
import '../login/login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  TextEditingController fnameController = TextEditingController();
  TextEditingController emailController2 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
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
                            "SignUp",
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
                              controller: fnameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Username",
                                hintStyle: TextStyle(color: Colors.grey[400]),

                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.black))),
                            child: TextField(
                              keyboardType: TextInputType.name,
                              controller: emailController2,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.black))),
                            child: TextField(
                              keyboardType: TextInputType.name,
                              controller: passwordController2,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey[400]),

                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              keyboardType: TextInputType.name,
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(color: Colors.grey[400]),

                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: signUpFunction,
                      //defining the shape
                      color: Color(0xFF94C3DD),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void signUpFunction() {
    if (fnameController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Provide Username"),
      );
      return;
    }
    else if (emailController2.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Provide Email"),
      );
      return;
    }
    else if (!EmailValidator.validate(emailController2.text, true)) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Invalid Email"),
      );
      return;
    } else if (passwordController2.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Provide Password"),
      );
      return;
    } else if (confirmPasswordController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Please Confirm Password"),
      );
      return;
    }
    else if (passwordController2.text != confirmPasswordController.text) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Passwords do not match"),
      );
      return;
    } else { //call singup function
      print(fnameController.text);
      print(emailController2.text);
      print(passwordController2.text);
      print(confirmPasswordController.text);

      signUp(fnameController.text,emailController2.text, passwordController2.text);
    }
  }

  signUp(String email, String password, String fname) async {
    DialogBuilder(context).showLoadingIndicator(
        "Please wait as we create your account", "Creating");
    Map data = {'email': email, 'password': password, 'fname': fname};
    var jsonResponse;
    var response = await http.post(
        Uri.parse("https://medihealth2.000webhostapp.com/register.php"),
        body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          DialogBuilder(context).hideOpenDialog();
        });
        int isRegistered = jsonResponse['code'];
        if (isRegistered == 1) {//correct password
          //move to dashboard
          scaffoldMessenger.showSnackBar(
            mySnackBar("Account Created Successfully"),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => firstLoginPage()));
        } else {

          scaffoldMessenger.showSnackBar(
            mySnackBar("Email is already associated with an Account"),
          );
        }
      }
    } else {


      setState(() {
        DialogBuilder(context).hideOpenDialog();
      });
    }
  }

  void validateEmail(String email) {
    if(email.isEmpty){
      setState(() {
        scaffoldMessenger.showSnackBar(
          mySnackBar("Provide Email"),
        );
      });
    }else if(!EmailValidator.validate(email, true)){
      setState(() {
        scaffoldMessenger.showSnackBar(
          mySnackBar("Invalid Email"),
        );
      });
    }
    else{
    }
  }



}
