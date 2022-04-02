import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medi_health1/Screens/login/login.dart';

import '../../Constants.dart';
import '../../mywidget.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();
  late ScaffoldMessengerState scaffoldMessenger;



  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);

    //String message = "Hello";

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
                            "Forgot Password",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
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
                    Text(
                      "Enter the Email Address linked to your account",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                            child: TextField(
                              keyboardType: TextInputType.name,
                              controller: emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: retrievePasswordFunction,
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
                    ),
                    SizedBox(
                      height: 40,
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

  void retrievePasswordFunction() {
    if (emailController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Provide Email"),
      );
      return;
    } else {

      retrievePassword(emailController.text);
    }
  }

  retrievePassword(String email) async {
    DialogBuilder(context).showLoadingIndicator(
        "Please wait as we Retrieve your password", "Retrieving");
    Map data = {'email': email};
    var jsonResponse;
    var response = await http.post(
        Uri.parse("https://medihealth2.000webhostapp.com/retreivePassword.php"),
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
        var retreivedPassword = jsonResponse['password'];

        if (isRegistered == 1) {
          _showBottomSheet(context, retreivedPassword);

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

  _showBottomSheet(context, String message){
    showModalBottomSheet(context: context, builder: (BuildContext c){
      return Container(
        height: MediaQuery.of(context).size.height*0.45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Password Retrieved", style: HeadingStyle,),
            ),

            Divider(
              height: 2.0,
            ),

            ListTile(
              title: Text("Your password has been Retrieved BELOW!!! ",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),

            Divider(
              height: 2.0,
            ),

            ListTile(
              title: Text("Make sure you change it on your Accounts settings once you log in!!!",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Divider(
              height: 2.0,
            ),

            ListTile(
              title: Text("Password : $message",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),

            Divider(
              height: 2.0,
            ),

            _botomButton(label: "Go to Login", onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => firstLoginPage()));
            }, clr: primaryColor, context: context),

          ],
        ),
      );
    });
  }

  _botomButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  })
  {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose==true?Colors.grey[300]!:clr
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose==true?Colors.transparent:clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );

  }
}
